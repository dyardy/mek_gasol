// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_slip_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$PaySlipDto {
  PaySlipDto get _self => this as PaySlipDto;

  Iterable<Object?> get _props sync* {
    yield _self.month;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$PaySlipDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('PaySlipDto')..add('month', _self.month)).toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaySlipDto _$PaySlipDtoFromJson(Map<String, dynamic> json) => PaySlipDto(
      month: DateTime.parse(json['month'] as String),
    );

Map<String, dynamic> _$PaySlipDtoToJson(PaySlipDto instance) =>
    <String, dynamic>{
      'month': instance.month.toIso8601String(),
    };
