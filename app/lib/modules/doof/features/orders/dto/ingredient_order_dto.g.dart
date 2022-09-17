// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_order_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$IngredientOrderDto {
  IngredientOrderDto get _self => this as IngredientOrderDto;

  Iterable<Object?> get _props sync* {
    yield _self.ingredient;
    yield _self.value;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$IngredientOrderDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('IngredientOrderDto')
        ..add('ingredient', _self.ingredient)
        ..add('value', _self.value))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientOrderDto _$IngredientOrderDtoFromJson(Map<String, dynamic> json) =>
    IngredientOrderDto(
      ingredient:
          IngredientDto.fromJson(json['ingredient'] as Map<String, dynamic>),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$IngredientOrderDtoToJson(IngredientOrderDto instance) =>
    <String, dynamic>{
      'ingredient': instance.ingredient.toJson(),
      'value': instance.value,
    };
