// ignore_for_file: avoid_print

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart'
    show AnalysisContextCollection;
import 'package:analyzer/dart/analysis/results.dart' show ParsedUnitResult;
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart' show RecursiveAstVisitor, ThrowingAstVisitor;
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as path_;

const isDebug = false;

const includeGlobs = [
  if (isDebug) ...[
    // 'lib/**/addition_dto.dart',
    'lib/**/order_dto.dart',
  ] else
    'lib/**/*_dto.dart',
];

const outputPath = '../functions/src/lib/dto.ts';

void main() {
  final includeRelativePaths = includeGlobs.expand((e) => Glob(e).listSync()).map((e) => e.path);
  final includeAbsolutePaths = includeRelativePaths.map((folder) {
    return path_.absolute(path_.normalize(folder));
  }).toList();

  final analyzer = AnalysisContextCollection(
    includedPaths: includeAbsolutePaths,
  );

  final entriesBuffer = StringBuffer();
  final serializersBuffer = StringBuffer();

  for (final context in analyzer.contexts) {
    for (final path in context.contextRoot.analyzedFiles()) {
      final result = context.currentSession.getParsedUnit(path) as ParsedUnitResult;
      if (result.errors.isEmpty) {
        final unit = result.unit;
        final classesVisitor = _ClassesVisitor();
        final enumsVisitor = _EnumsVisitor();

        unit.accept(classesVisitor);
        unit.accept(enumsVisitor);

        if (enumsVisitor.enumsBuffer.isNotEmpty) entriesBuffer.writeln();
        entriesBuffer.write(enumsVisitor.enumsBuffer);

        if (classesVisitor.classesBuffer.isNotEmpty) entriesBuffer.writeln();
        entriesBuffer.write(classesVisitor.classesBuffer);

        serializersBuffer.write(enumsVisitor.serializersBuffer);

        if (serializersBuffer.isNotEmpty && classesVisitor.serializersBuffer.isNotEmpty) {
          serializersBuffer.writeln();
        }
        serializersBuffer.write(classesVisitor.serializersBuffer);
      } else {
        throw result.errors;
      }
    }
  }

  final contentBuffer = StringBuffer();
  contentBuffer.writeln('import Decimal from "decimal.js";');
  contentBuffer.writeln('import { firestore } from "firebase-admin";');
  contentBuffer.writeln('import Timestamp = firestore.Timestamp;');

  contentBuffer.writeln(entriesBuffer);

  contentBuffer.writeln('export abstract class Serializers {');
  contentBuffer.write(serializersBuffer);
  contentBuffer.writeln('}');

  if (isDebug) {
    print(contentBuffer);
    return;
  }
  File(outputPath).writeAsStringSync(contentBuffer.toString());
}

class _ClassesVisitor extends RecursiveAstVisitor<void> {
  final classesBuffer = StringBuffer();
  final serializersBuffer = StringBuffer();

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (serializersBuffer.isNotEmpty) serializersBuffer.writeln();
    if (classesBuffer.isNotEmpty) classesBuffer.writeln();
    serializersBuffer.writeln('  static serialize${node.name}(value: ${node.name}) {');
    serializersBuffer.writeln('    return {');
    classesBuffer.writeln('export interface ${node.name} {');
    super.visitClassDeclaration(node);
    classesBuffer.writeln('}');
    serializersBuffer.writeln('    }');
    serializersBuffer.writeln('  }');
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    if (node.isStatic) return;
    super.visitFieldDeclaration(node);
  }

  String? _type;
  String? _name;

  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    super.visitVariableDeclarationList(node);
    classesBuffer.writeln('  readonly $_name: $_type;');
    final accessToken = _SerializeVisitor('value.$_name').visitVariableDeclarationList(node);
    serializersBuffer.writeln('      $_name: $accessToken,');
  }

  @override
  void visitNamedType(NamedType node) {
    _type = const _TypeVisitor().visitNamedType(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    _name = '${node.name}';
    super.visitVariableDeclaration(node);
  }
}

class _SerializeVisitor extends ThrowingAstVisitor<String> {
  final String accessToken;

  const _SerializeVisitor(this.accessToken);

  @override
  String visitVariableDeclarationList(VariableDeclarationList node) {
    return node.type!.accept(this)!;
  }

  @override
  String visitNamedType(NamedType node) {
    // final subTypes = node.typeArguments?.accept(this);
    return _mapType(node);
  }

  // @override
  // String visitTypeArgumentList(TypeArgumentList node) {
  //   return '<${node.arguments.map((e) => e.accept(this)).join(', ')}>';
  // }

  String _mapType(NamedType namedType) {
    final type = namedType.name.name;
    switch (type) {
      case 'DateTime':
        return 'Timestamp.fromDate($accessToken)';
      default:
        return accessToken;
    }
  }
}

class _EnumsVisitor extends RecursiveAstVisitor<void> {
  final enumsBuffer = StringBuffer();
  final serializersBuffer = StringBuffer();

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    enumsBuffer.writeln('export enum ${node.name} {');
    super.visitEnumDeclaration(node);
    enumsBuffer.writeln('}');
  }

  @override
  void visitEnumConstantDeclaration(EnumConstantDeclaration node) {
    enumsBuffer.writeln('  ${node.name} = "${node.name}",');
  }
}

class _TypeVisitor extends ThrowingAstVisitor<String> {
  const _TypeVisitor();

  @override
  String visitNamedType(NamedType node) {
    final subTypes = node.typeArguments?.accept(this);
    return '${_mapType(node)}${subTypes ?? ''}';
  }

  @override
  String visitTypeArgumentList(TypeArgumentList node) {
    return '<${node.arguments.map((e) => e.accept(this)).join(', ')}>';
  }

  String _mapType(NamedType namedType) {
    final type = namedType.name.name;
    switch (type) {
      case 'String':
        return 'string';
      case 'int':
      case 'double':
        return 'number';
      case 'DateTime':
        return 'Date';
      case 'List':
        return 'ReadonlyArray';
      default:
        return type;
    }
  }
}
