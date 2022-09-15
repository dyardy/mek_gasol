// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_dvo.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$ProjectDvo {
  ProjectDvo get _self => this as ProjectDvo;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.name;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ProjectDvo &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('ProjectDvo')
        ..add('id', _self.id)
        ..add('name', _self.name))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectDvo _$ProjectDvoFromJson(Map<String, dynamic> json) => ProjectDvo(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProjectDvoToJson(ProjectDvo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
