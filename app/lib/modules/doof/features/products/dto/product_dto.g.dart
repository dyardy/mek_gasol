// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$ProductDto {
  ProductDto get _self => this as ProductDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.title;
    yield _self.description;
    yield _self.price;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ProductDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('ProductDto')
        ..add('id', _self.id)
        ..add('title', _self.title)
        ..add('description', _self.description)
        ..add('price', _self.price))
      .toString();
}

class ProductDtoFields {
  final String _path;

  const ProductDtoFields([this._path = '']);

  String get id => '${_path}id';
  String get title => '${_path}title';
  String get description => '${_path}description';
  String get price => '${_path}price';

  String toString() => _path.isEmpty ? 'ProductDtoFields()' : _path;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: Decimal.fromJson(json['price'] as String),
    );

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price.toJson(),
    };
