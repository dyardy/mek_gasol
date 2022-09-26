// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$IngredientDto {
  IngredientDto get _self => this as IngredientDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.productIds;
    yield _self.title;
    yield _self.description;
    yield _self.minLevel;
    yield _self.maxLevel;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$IngredientDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('IngredientDto')
        ..add('id', _self.id)
        ..add('productIds', _self.productIds)
        ..add('title', _self.title)
        ..add('description', _self.description)
        ..add('minLevel', _self.minLevel)
        ..add('maxLevel', _self.maxLevel))
      .toString();
}

class IngredientDtoFields {
  final String _path;

  const IngredientDtoFields([this._path = '']);

  String get id => '${_path}id';
  String get productIds => '${_path}productIds';
  String get title => '${_path}title';
  String get description => '${_path}description';
  String get minLevel => '${_path}minLevel';
  String get maxLevel => '${_path}maxLevel';

  String toString() => _path.isEmpty ? 'IngredientDtoFields()' : _path;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientDto _$IngredientDtoFromJson(Map<String, dynamic> json) =>
    IngredientDto(
      id: json['id'] as String,
      productIds: (json['productIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      description: json['description'] as String,
      minLevel: json['minLevel'] as int,
      maxLevel: json['maxLevel'] as int,
    );

Map<String, dynamic> _$IngredientDtoToJson(IngredientDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productIds': instance.productIds,
      'title': instance.title,
      'description': instance.description,
      'minLevel': instance.minLevel,
      'maxLevel': instance.maxLevel,
    };
