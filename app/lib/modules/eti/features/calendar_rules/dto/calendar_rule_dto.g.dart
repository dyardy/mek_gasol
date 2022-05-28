// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_rule_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$WorkRuleCalendarDto {
  WorkRuleCalendarDto get _self => this as WorkRuleCalendarDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.type;
    yield _self.startAt;
    yield _self.endAt;
    yield _self.weekDays;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$WorkRuleCalendarDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('WorkRuleCalendarDto')
        ..add('id', _self.id)
        ..add('type', _self.type)
        ..add('startAt', _self.startAt)
        ..add('endAt', _self.endAt)
        ..add('weekDays', _self.weekDays))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkRuleCalendarDto _$WorkRuleCalendarDtoFromJson(Map json) =>
    WorkRuleCalendarDto(
      id: json['id'] as String,
      type: $enumDecodeNullable(_$RuleCalendarDtoTypeEnumMap, json['type']) ??
          RuleCalendarDtoType.work,
      startAt: Duration(microseconds: json['startAt'] as int),
      endAt: Duration(microseconds: json['endAt'] as int),
      weekDays: ((json['weekDays'] as List)
          .map((e) => $enumDecode(_$WeekDayEnumMap, e))).toBuiltList(),
    );

Map<String, dynamic> _$WorkRuleCalendarDtoToJson(
        WorkRuleCalendarDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$RuleCalendarDtoTypeEnumMap[instance.type],
      'startAt': instance.startAt.inMicroseconds,
      'endAt': instance.endAt.inMicroseconds,
      'weekDays': instance.weekDays.map((e) => _$WeekDayEnumMap[e]).toList(),
    };

const _$RuleCalendarDtoTypeEnumMap = {
  RuleCalendarDtoType.work: 'work',
};

const _$WeekDayEnumMap = {
  WeekDay.monday: 'monday',
  WeekDay.tuesday: 'tuesday',
  WeekDay.wednesday: 'wednesday',
  WeekDay.thursday: 'thursday',
  WeekDay.friday: 'friday',
  WeekDay.saturday: 'saturday',
  WeekDay.sunday: 'sunday',
};
