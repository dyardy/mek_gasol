// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_event_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$WorkEventDto {
  WorkEventDto get _self => this as WorkEventDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.creatorUserId;
    yield _self.startAt;
    yield _self.endAt;
    yield _self.note;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$WorkEventDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('WorkEventDto')
        ..add('id', _self.id)
        ..add('creatorUserId', _self.creatorUserId)
        ..add('startAt', _self.startAt)
        ..add('endAt', _self.endAt)
        ..add('note', _self.note))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkEventDto _$WorkEventDtoFromJson(Map json) => WorkEventDto(
      id: json['id'] as String,
      creatorUserId: json['creatorUserId'] as String,
      startAt:
          const TimestampJsonConvert().fromJson(json['startAt'] as Timestamp),
      endAt: const TimestampJsonConvert().fromJson(json['endAt'] as Timestamp),
      note: json['note'] as String,
    );

Map<String, dynamic> _$WorkEventDtoToJson(WorkEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorUserId': instance.creatorUserId,
      'startAt': const TimestampJsonConvert().toJson(instance.startAt),
      'endAt': const TimestampJsonConvert().toJson(instance.endAt),
      'note': instance.note,
    };
