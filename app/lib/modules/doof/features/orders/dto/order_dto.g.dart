// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$OrderDto {
  OrderDto get _self => this as OrderDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.createdAt;
    yield _self.status;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$OrderDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('OrderDto')
        ..add('id', _self.id)
        ..add('createdAt', _self.createdAt)
        ..add('status', _self.status))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
      id: json['id'] as String,
      createdAt:
          const TimestampJsonConvert().fromJson(json['createdAt'] as Timestamp),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': const TimestampJsonConvert().toJson(instance.createdAt),
      'status': _$OrderStatusEnumMap[instance.status]!,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.draft: 'draft',
  OrderStatus.sent: 'sent',
};
