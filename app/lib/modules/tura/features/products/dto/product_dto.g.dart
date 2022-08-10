// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

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
