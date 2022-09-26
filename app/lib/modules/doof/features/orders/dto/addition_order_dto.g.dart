// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addition_order_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$AdditionOrderDto {
  AdditionOrderDto get _self => this as AdditionOrderDto;

  Iterable<Object?> get _props sync* {
    yield _self.addition;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$AdditionOrderDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() =>
      (ClassToString('AdditionOrderDto')..add('addition', _self.addition)).toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdditionOrderDto _$AdditionOrderDtoFromJson(Map<String, dynamic> json) =>
    AdditionOrderDto(
      addition: AdditionDto.fromJson(json['addition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdditionOrderDtoToJson(AdditionOrderDto instance) =>
    <String, dynamic>{
      'addition': instance.addition.toJson(),
    };
