import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mek_gasol/modules/eti/features/work_events/calendar.dart';
import 'package:mek_gasol/modules/eti/features/work_events/dvo/work_event_dvo.dart';
import 'package:mek_gasol/modules/eti/features/work_events/screens/work_event.dart';
import 'package:mek_gasol/shared/app_list_tile.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:pure_extensions/pure_extensions.dart';

abstract class WorkEventsBloc {
  static final dayFilter = StateProvider.family((ref, DateTime initialDay) {
    return initialDay;
  });

  static final events = FutureProvider.family((ref, DateTime day) async {
    final events = await ref.watch(CalendarBloc.events(day.copyUpTo(month: true)).future);
    return events.where((event) {
      return event.startAt.isBetween(day, day.add(const Duration(days: 1)));
    }).toBuiltList();
  });
}

class WorkEventsScreen extends ConsumerWidget {
  final DateTime initialDay;

  const WorkEventsScreen({
    Key? key,
    required this.initialDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayProvider = WorkEventsBloc.dayFilter(initialDay);

    final day = ref.watch(dayProvider);
    final eventsState = ref.watch(WorkEventsBloc.events(day));

    final languageTag = Localizations.localeOf(context).toLanguageTag();
    final titleDateTimeFormat = DateFormat(null, languageTag).addPattern('EEEE').add_yMd();
    final cellDateTimeFormat = DateFormat(null, languageTag).add_Hm();

    Widget _buildCells(BuiltList<WorkEventDvo> events) {
      if (events.isEmpty) {
        return InkWell(
          onTap: () => Hub.push(WorkEventScreen(
            day: day,
          )),
          child: const Center(
            child: Text('Tap to add new event!'),
          ),
        );
      }

      return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          return ListTile(
            title: Text(event.note),
            subtitle: Text(
                '${cellDateTimeFormat.format(event.startAt)} - ${cellDateTimeFormat.format(event.endAt)}\n${event.id}'),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titleDateTimeFormat.format(day)),
        actions: [
          IconButton(
            onPressed: () => Hub.push(WorkEventScreen(
              day: day,
            )),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            BarCalendar(
              firstDate: DateTime.now().subtract(const Duration(days: 100)),
              initialDate: day,
              lastDate: DateTime.now().add(const Duration(days: 100)),
              onDateChanged: (date) => ref.read(dayProvider.notifier).state = date,
            ),
            Expanded(
              child: eventsState.when(
                loading: () => const MekProgressIndicator(),
                error: (_, __) => const MekCrashIndicator(),
                data: (events) => _buildCells(events),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

    Widget _buildTapDetector({
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

    Widget _buildScrollableBar({
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
        _buildScrollableBar(
          height: 40.0,
          itemCount: months.length,
          itemBuilder: (context, index) {
            final month = months[index];

            return SizedBox(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: _buildTapDetector(
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
        _buildScrollableBar(
          height: 56.0,
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];

            return SizedBox(
              width: 48.0,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: _buildTapDetector(
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

class ListCalendar extends StatelessWidget {
  final DateTime day;
  final BuiltList<WorkEventDvo> events;

  const ListCalendar({
    Key? key,
    required this.day,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageTag = Localizations.localeOf(context).toLanguageTag();
    final cellDateTimeFormat = DateFormat(null, languageTag).add_Hm();

    Widget _buildCell({required DateTime dateTime, required Widget child}) {
      return AppListTile(
        leading: Text(cellDateTimeFormat.format(dateTime)),
        title: child,
      );
    }

    Widget _buildWorkEventTile(DateTime cellTime, WorkEventDvo event) {
      return _buildCell(
        dateTime: cellTime,
        child: Text(event.id),
      );
    }

    Widget _buildEmptyTile(DateTime cellTime) {
      return _buildCell(
        dateTime: cellTime,
        child: const SizedBox.shrink(),
      );
    }

    final cells = <Widget>[];
    for (var i = 0; i < 8; i++) {
      final cellTime = day.copyWith(hour: 9 + i);
      final event = events.firstWhereOrNull((e) => cellTime.isBetween(e.startAt, e.endAt));

      if (event != null) {
        cells.add(_buildWorkEventTile(cellTime, event));
      } else {
        cells.add(_buildEmptyTile(cellTime));
      }
    }
    return Column(
      children: cells.map((e) => Expanded(child: e)).toList(),
    );
  }
}

class DefaultPrimaryScrollController extends StatefulWidget {
  final Widget child;

  const DefaultPrimaryScrollController({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<DefaultPrimaryScrollController> createState() => _DefaultPrimaryScrollControllerState();
}

class _DefaultPrimaryScrollControllerState extends State<DefaultPrimaryScrollController> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _controller,
      child: widget.child,
    );
  }
}
