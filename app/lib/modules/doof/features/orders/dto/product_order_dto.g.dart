// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_order_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$ProductOrderDto {
  ProductOrderDto get _self => this as ProductOrderDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.user;
    yield _self.product;
    yield _self.quantity;
    yield _self.additions;
    yield _self.ingredients;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ProductOrderDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('ProductOrderDto')
        ..add('id', _self.id)
        ..add('user', _self.user)
        ..add('product', _self.product)
        ..add('quantity', _self.quantity)
        ..add('additions', _self.additions)
        ..add('ingredients', _self.ingredients))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOrderDto _$ProductOrderDtoFromJson(Map<String, dynamic> json) =>
    ProductOrderDto(
      id: json['id'] as String,
      user: PublicUserDto.fromJson(json['user'] as Map<String, dynamic>),
      product: ProductDto.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      additions: (json['additions'] as List<dynamic>)
          .map((e) => AdditionOrderDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => IngredientOrderDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductOrderDtoToJson(ProductOrderDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
      'product': instance.product.toJson(),
      'quantity': instance.quantity,
      'additions': instance.additions.map((e) => e.toJson()).toList(),
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
    };
