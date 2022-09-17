// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_order_dvo.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$ProductOrderDvo {
  ProductOrderDvo get _self => this as ProductOrderDvo;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.user;
    yield _self.productId;
    yield _self.title;
    yield _self.description;
    yield _self.price;
    yield _self.quantity;
    yield _self.additions;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ProductOrderDvo &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('ProductOrderDvo')
        ..add('id', _self.id)
        ..add('user', _self.user)
        ..add('productId', _self.productId)
        ..add('title', _self.title)
        ..add('description', _self.description)
        ..add('price', _self.price)
        ..add('quantity', _self.quantity)
        ..add('additions', _self.additions))
      .toString();
}
