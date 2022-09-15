// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_order_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$ProductOrderDto {
  ProductOrderDto get _self => this as ProductOrderDto;

  Iterable<Object?> get _props sync* {
    yield _self.userId;
    yield _self.productId;
    yield _self.title;
    yield _self.description;
    yield _self.price;
    yield _self.quantity;
    yield _self.additions;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ProductOrderDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('ProductOrderDto')
        ..add('userId', _self.userId)
        ..add('productId', _self.productId)
        ..add('title', _self.title)
        ..add('description', _self.description)
        ..add('price', _self.price)
        ..add('quantity', _self.quantity)
        ..add('additions', _self.additions))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOrderDto _$ProductOrderDtoFromJson(Map<String, dynamic> json) =>
    ProductOrderDto(
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: Decimal.fromJson(json['price'] as String),
      quantity: json['quantity'] as int,
      additions: json['additions'] as List<dynamic>,
    );

Map<String, dynamic> _$ProductOrderDtoToJson(ProductOrderDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'productId': instance.productId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price.toJson(),
      'quantity': instance.quantity,
      'additions': instance.additions,
    };
