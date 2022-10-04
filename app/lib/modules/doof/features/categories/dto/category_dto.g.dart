// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$CategoryDto {
  CategoryDto get _self => this as CategoryDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.title;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$CategoryDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('CategoryDto')
        ..add('id', _self.id)
        ..add('title', _self.title))
      .toString();
}

class CategoryDtoFields {
  final String _path;

  const CategoryDtoFields([this._path = '']);

  String get id => '${_path}id';
  String get title => '${_path}title';

  String toString() => _path.isEmpty ? 'CategoryDtoFields()' : _path;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => CategoryDto(
      id: json['id'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
