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
import 'package:mek_gasol/shared/widgets/bar_calendar.dart';
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
