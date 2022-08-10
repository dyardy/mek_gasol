// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:mek_adaptable/mek_adaptable.dart';
import 'package:mek_gasol/modules/tura/features/products/dto/product_dto.dart';
import 'package:decimal/decimal.dart';

class ProductDtoAdapter extends StructuredAdapter<ProductDto> {
  @override
  String get wireName => 'ProductDto';
  @override
  ProductDto deserialize(Adapters adapters, Map<String, dynamic> map,
      {ItemType? type, ItemFormat? format}) {
    return ProductDto(
      id: adapters.deserializeAny(map['id'], type: const ItemType(String)),
      title:
          adapters.deserializeAny(map['title'], type: const ItemType(String)),
      description: adapters.deserializeAny(map['description'],
          type: const ItemType(String)),
      price:
          adapters.deserializeAny(map['price'], type: const ItemType(Decimal)),
    );
  }

  @override
  Map<String, dynamic> serialize(Adapters adapters, ProductDto item,
      {ItemType? type, ItemFormat? format}) {
    return <String, dynamic>{
      'id': adapters.serializeAny(item.id, type: const ItemType(String)),
      'title': adapters.serializeAny(item.title, type: const ItemType(String)),
      'description':
          adapters.serializeAny(item.description, type: const ItemType(String)),
      'price': adapters.serializeAny(item.price, type: const ItemType(Decimal)),
    };
  }
}
