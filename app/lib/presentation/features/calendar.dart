import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/work_events/dvo/work_event_dvo.dart';
import 'package:mek_gasol/features/work_events/triggers/work_event_trigger.dart';
import 'package:mek_gasol/presentation/features/work_events.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:pure_extensions/pure_extensions.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class CalendarBloc {
  static final events = StreamProvider.family((ref, DateTime moth) async* {
    final user = await ref.watch(Providers.user.future);

    yield* ref.read(WorkEventTrigger.instance).watchMonth(user.id, moth);
  });
}

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = DateTime.now().copyUpTo(month: true);

    Widget _buildCalendar(BuiltList<WorkEventDvo> events) {
      return TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 360)),
        focusedDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 360)),
        onDaySelected: (selectedDay, _) {
          Hub.push(WorkEventsScreen(initialDay: selectedDay.toLocal().copyUpTo(day: true)));
        },
      );
    }

    Widget _buildSummary(BuiltList<WorkEventDvo> events) {
      final groupedEvents = events.groupListsBy((event) => event.creatorUser);

      return DataTable(
        columns: const [
          DataColumn(label: Text('Workers')),
          DataColumn(label: Text('Hours')),
        ],
        rows: groupedEvents.generateIterable((user, events) {
          final hours = events.fold<Duration>(Duration.zero, (total, event) {
            return total + event.endAt.difference(event.startAt);
          });
          return DataRow(
            cells: [
              DataCell(Text(user.email)),
              DataCell(Text('${hours.hours}:${hours.minutes}')),
            ],
          );
        }).toList(),
      );
    }

    final eventsState = ref.watch(CalendarBloc.events(month));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: eventsState.when(
        loading: () => const MekProgressIndicator(),
        error: (_, __) => const MekCrashIndicator(),
        data: (events) {
          return Column(
            children: [
              _buildCalendar(events),
              _buildSummary(events),
            ],
          );
        },
      ),
    );
  }
}
