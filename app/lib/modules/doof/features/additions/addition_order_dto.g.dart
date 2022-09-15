// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addition_order_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$AdditionOrderDto {
  AdditionOrderDto get _self => this as AdditionOrderDto;

  Iterable<Object?> get _props sync* {
    yield _self.additionId;
    yield _self.title;
    yield _self.description;
    yield _self.price;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$AdditionOrderDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('AdditionOrderDto')
        ..add('additionId', _self.additionId)
        ..add('title', _self.title)
        ..add('description', _self.description)
        ..add('price', _self.price))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdditionOrderDto _$AdditionOrderDtoFromJson(Map<String, dynamic> json) =>
    AdditionOrderDto(
      additionId: json['additionId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: Decimal.fromJson(json['price'] as String),
    );

Map<String, dynamic> _$AdditionOrderDtoToJson(AdditionOrderDto instance) =>
    <String, dynamic>{
      'additionId': instance.additionId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price.toJson(),
    };
