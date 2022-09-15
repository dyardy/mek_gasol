// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$WorkEventCalendarDto {
  WorkEventCalendarDto get _self => this as WorkEventCalendarDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.type;
    yield _self.createdBy;
    yield _self.startAt;
    yield _self.endAt;
    yield _self.note;
    yield _self.isPaid;
    yield _self.clientId;
    yield _self.projectId;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$WorkEventCalendarDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('WorkEventCalendarDto')
        ..add('id', _self.id)
        ..add('type', _self.type)
        ..add('createdBy', _self.createdBy)
        ..add('startAt', _self.startAt)
        ..add('endAt', _self.endAt)
        ..add('note', _self.note)
        ..add('isPaid', _self.isPaid)
        ..add('clientId', _self.clientId)
        ..add('projectId', _self.projectId))
      .toString();
}

mixin _$HolidayEventCalendarDto {
  HolidayEventCalendarDto get _self => this as HolidayEventCalendarDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.type;
    yield _self.createdBy;
    yield _self.startAt;
    yield _self.endAt;
    yield _self.note;
    yield _self.isPaid;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$HolidayEventCalendarDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('HolidayEventCalendarDto')
        ..add('id', _self.id)
        ..add('type', _self.type)
        ..add('createdBy', _self.createdBy)
        ..add('startAt', _self.startAt)
        ..add('endAt', _self.endAt)
        ..add('note', _self.note)
        ..add('isPaid', _self.isPaid))
      .toString();
}

mixin _$VacationEventCalendarDto {
  VacationEventCalendarDto get _self => this as VacationEventCalendarDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.type;
    yield _self.createdBy;
    yield _self.startAt;
    yield _self.endAt;
    yield _self.note;
    yield _self.isPaid;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$VacationEventCalendarDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('VacationEventCalendarDto')
        ..add('id', _self.id)
        ..add('type', _self.type)
        ..add('createdBy', _self.createdBy)
        ..add('startAt', _self.startAt)
        ..add('endAt', _self.endAt)
        ..add('note', _self.note)
        ..add('isPaid', _self.isPaid))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkEventCalendarDto _$WorkEventCalendarDtoFromJson(
        Map<String, dynamic> json) =>
    WorkEventCalendarDto(
      id: json['id'] as String,
      type: $enumDecodeNullable(_$EventCalendarDtoTypeEnumMap, json['type']) ??
          EventCalendarDtoType.work,
      createdBy: json['createdBy'] as String,
      startAt:
          const TimestampJsonConvert().fromJson(json['startAt'] as Timestamp),
      endAt: const TimestampJsonConvert().fromJson(json['endAt'] as Timestamp),
      note: json['note'] as String,
      isPaid: json['isPaid'] as bool,
      clientId: json['clientId'] as String,
      projectId: json['projectId'] as String,
    );

Map<String, dynamic> _$WorkEventCalendarDtoToJson(
        WorkEventCalendarDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$EventCalendarDtoTypeEnumMap[instance.type]!,
      'createdBy': instance.createdBy,
      'startAt': const TimestampJsonConvert().toJson(instance.startAt),
      'endAt': const TimestampJsonConvert().toJson(instance.endAt),
      'note': instance.note,
      'isPaid': instance.isPaid,
      'clientId': instance.clientId,
      'projectId': instance.projectId,
    };

const _$EventCalendarDtoTypeEnumMap = {
  EventCalendarDtoType.work: 'work',
  EventCalendarDtoType.holiday: 'holiday',
  EventCalendarDtoType.vacation: 'vacation',
};

HolidayEventCalendarDto _$HolidayEventCalendarDtoFromJson(
        Map<String, dynamic> json) =>
    HolidayEventCalendarDto(
      id: json['id'] as String,
      type: $enumDecodeNullable(_$EventCalendarDtoTypeEnumMap, json['type']) ??
          EventCalendarDtoType.holiday,
      createdBy: json['createdBy'] as String,
      startAt:
          const TimestampJsonConvert().fromJson(json['startAt'] as Timestamp),
      endAt: const TimestampJsonConvert().fromJson(json['endAt'] as Timestamp),
      note: json['note'] as String,
      isPaid: json['isPaid'] as bool,
    );

Map<String, dynamic> _$HolidayEventCalendarDtoToJson(
        HolidayEventCalendarDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$EventCalendarDtoTypeEnumMap[instance.type]!,
      'createdBy': instance.createdBy,
      'startAt': const TimestampJsonConvert().toJson(instance.startAt),
      'endAt': const TimestampJsonConvert().toJson(instance.endAt),
      'note': instance.note,
      'isPaid': instance.isPaid,
    };

VacationEventCalendarDto _$VacationEventCalendarDtoFromJson(
        Map<String, dynamic> json) =>
    VacationEventCalendarDto(
      id: json['id'] as String,
      type: $enumDecodeNullable(_$EventCalendarDtoTypeEnumMap, json['type']) ??
          EventCalendarDtoType.vacation,
      createdBy: json['createdBy'] as String,
      startAt:
          const TimestampJsonConvert().fromJson(json['startAt'] as Timestamp),
      endAt: const TimestampJsonConvert().fromJson(json['endAt'] as Timestamp),
      note: json['note'] as String,
      isPaid: json['isPaid'] as bool,
    );

Map<String, dynamic> _$VacationEventCalendarDtoToJson(
        VacationEventCalendarDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$EventCalendarDtoTypeEnumMap[instance.type]!,
      'createdBy': instance.createdBy,
      'startAt': const TimestampJsonConvert().toJson(instance.startAt),
      'endAt': const TimestampJsonConvert().toJson(instance.endAt),
      'note': instance.note,
      'isPaid': instance.isPaid,
    };
