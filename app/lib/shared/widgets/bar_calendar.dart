import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/widgets/controllers/default_primary_scroll_controller.dart';
import 'package:pure_extensions/pure_extensions.dart';

class BarCalendar extends StatelessWidget {
  final DateTime firstDate;
  final DateTime initialDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateChanged;

  const BarCalendar({
    Key? key,
    required this.firstDate,
    required this.initialDate,
    required this.lastDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat.MMMM();
    final dayFormat = DateFormat.d();

    final months = <DateTime>[];
    var currentMonth = firstDate.toUtc().copyUpTo(month: true).copyWith(month: firstDate.month + 1);
    while (currentMonth.isBefore(lastDate)) {
      months.add(currentMonth);
      currentMonth = currentMonth.copyWith(month: currentMonth.month + 1);
    }

    final initialDay = initialDate.toUtc().copyUpTo(month: true).copyWith(day: 1);
    final lastDay = initialDay.copyWith(month: initialDay.month + 1);
    final days = <DateTime>[];
    var currentDay = initialDay;
    while (currentDay.isBefore(lastDay)) {
      days.add(currentDay);
      currentDay = currentDay.copyWith(day: currentDay.day + 1);
    }

    Widget buildTapDetector({
      required VoidCallback? onTap,
      bool isSelected = false,
      required Widget child,
    }) {
      const padding = EdgeInsets.all(4.0);
      if (isSelected) {
        return ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: padding,
          ),
          child: child,
        );
      }
      return TextButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: padding,
        ),
        child: child,
      );
    }

    Widget buildScrollableBar({
      required double height,
      required int itemCount,
      required IndexedWidgetBuilder itemBuilder,
    }) {
      return SizedBox(
        height: height,
        child: DefaultPrimaryScrollController(
          child: Scrollbar(
            child: ListView.builder(
              primary: true,
              itemCount: itemCount,
              scrollDirection: Axis.horizontal,
              itemBuilder: itemBuilder,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        buildScrollableBar(
          height: 40.0,
          itemCount: months.length,
          itemBuilder: (context, index) {
            final month = months[index];

            return SizedBox(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: buildTapDetector(
                  isSelected: month.isAtSameMonthAs(initialDate),
                  onTap: () => onDateChanged(initialDate.copyWith(
                    year: month.year,
                    month: month.month,
                  )),
                  child: Text(monthFormat.format(month), style: const TextStyle(fontSize: 16.0)),
                ),
              ),
            );
          },
        ),
        buildScrollableBar(
          height: 56.0,
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];

            return SizedBox(
              width: 48.0,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: buildTapDetector(
                  isSelected: day.isAtSameDayAs(initialDate),
                  onTap: () => onDateChanged(initialDate.copyWith(
                    day: day.day,
                  )),
                  child: Text(dayFormat.format(day), style: const TextStyle(fontSize: 20.0)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
