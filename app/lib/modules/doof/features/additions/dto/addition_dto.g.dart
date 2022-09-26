// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addition_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$AdditionDto {
  AdditionDto get _self => this as AdditionDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.productIds;
    yield _self.title;
    yield _self.description;
    yield _self.price;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$AdditionDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('AdditionDto')
        ..add('id', _self.id)
        ..add('productIds', _self.productIds)
        ..add('title', _self.title)
        ..add('description', _self.description)
        ..add('price', _self.price))
      .toString();
}

class AdditionDtoFields {
  final String _path;

  const AdditionDtoFields([this._path = '']);

  String get id => '${_path}id';
  String get productIds => '${_path}productIds';
  String get title => '${_path}title';
  String get description => '${_path}description';
  String get price => '${_path}price';

  String toString() => _path.isEmpty ? 'AdditionDtoFields()' : _path;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdditionDto _$AdditionDtoFromJson(Map<String, dynamic> json) => AdditionDto(
      id: json['id'] as String,
      productIds: (json['productIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      description: json['description'] as String,
      price: Decimal.fromJson(json['price'] as String),
    );

Map<String, dynamic> _$AdditionDtoToJson(AdditionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productIds': instance.productIds,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price.toJson(),
    };
