import 'package:pure_extensions/pure_extensions.dart';

abstract class DateTimeUtils {
  static DateTime darwinAdd(DateTime dateTime, int months) {
    final totalMonths = (dateTime.month - 1) + months;
    final newMonth = (totalMonths % DateTime.monthsPerYear) + 1;
    final years = totalMonths ~/ DateTime.monthsPerYear;
    return dateTime.copyWith(year: dateTime.year + years, month: newMonth);
  }
}

extension CopyUpToDateTime on DateTime {
  DateTime copyUpTo({
    bool month = false,
    bool day = false,
    bool hour = false,
    bool minute = false,
    bool second = false,
    bool millisecond = false,
    bool microsecond = false,
  }) {
    return copyWith(
      month: month || day || hour || minute || second || millisecond || microsecond ? null : 1,
      day: day || hour || minute || second || millisecond || microsecond ? null : 1,
      hour: hour || minute || second || millisecond || microsecond ? null : 0,
      minute: minute || second || millisecond || microsecond ? null : 0,
      second: second || millisecond || microsecond ? null : 0,
      millisecond: millisecond || microsecond ? null : 0,
      microsecond: microsecond ? null : 0,
    );
  }
}

extension BetweenDateTime on DateTime {
  bool isBetween(DateTime after, DateTime before) =>
      (this == after || isAfter(after)) && (this == before || isBefore(before));
}

extension EqualsDateTime on DateTime {
  bool equalsUpTo(
    DateTime other, {
    bool year = false,
    bool month = false,
    bool day = false,
    bool hour = false,
    bool minute = false,
    bool second = false,
    bool millisecond = false,
  }) {
    if (this.year != other.year) return false;
    if (year) return true;
    if (this.month != other.month) return false;
    if (month) return true;
    if (this.day != other.day) return false;
    if (day) return true;
    if (this.hour != other.hour) return false;
    if (hour) return true;
    if (this.minute != other.minute) return false;
    if (minute) return true;
    if (this.second != other.second) return false;
    if (second) return true;
    if (this.millisecond != other.millisecond) return false;
    if (millisecond) return true;
    return true;
  }
}
