import 'package:built_collection/built_collection.dart';

enum RuleCalendarDtoType { work }

class RuleCalendarDto {
  const RuleCalendarDto();
}

class WorkRuleCalendarDto extends RuleCalendarDto {
  final RuleCalendarDtoType type;
  final Duration startAt;
  final Duration endAt;
  final BuiltList<WeekDay> weekDays;

  const WorkRuleCalendarDto({
    required this.type,
    required this.startAt,
    required this.endAt,
    required this.weekDays,
  });
}

enum WeekDay {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  final int number;

  const WeekDay(this.number);
}

// void main() {
//   DateTime.wednesday
// }
