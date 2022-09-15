import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/dvo/calendar_event_dvo.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/triggers/events_calendar_trigger.dart';
import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:mek_gasol/modules/eti/features/clients/triggers/clients_trigger.dart';
import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';
import 'package:mek_gasol/modules/eti/features/projects/triggers/projects_trigger.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/flutter_utils.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:mek_gasol/shared/riverpod_extensions.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';
import 'package:pure_extensions/pure_extensions.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/rivertion.dart';
import 'package:tuple/tuple.dart';

final _form = BlocProvider.family.autoDispose((ref, Tuple2<EventCalendarType, DateTime> args) {
  return _EventFormBloc(
    ref: ref,
    type: args.item1,
    day: args.item2,
  );
});

final _save = MutationProvider.family.autoDispose((ref, Tuple2<EventCalendarType, DateTime> args) {
  return MutationBloc((param) async {
    final day = args.item2;

    final trigger = ref.read(EventsCalendarTrigger.instance);
    final formBloc = ref.read(_form(args).bloc);
    final user = await ref.read(Providers.user.future);

    EventCalendarDvo event;
    switch (args.item1) {
      case EventCalendarType.work:
        event = WorkEventCalendarDvo(
          id: '',
          createdBy: user,
          startAt: formBloc.startAtFB.value!.toDateTime(day),
          endAt: formBloc.endAtFB.value!.toDateTime(day),
          note: formBloc.noteFB.value,
          client: formBloc.clientFB.value!,
          project: formBloc.projectFB.value!,
          isPaid: false,
        );
        break;
      case EventCalendarType.holiday:
        event = HolidayEventCalendarDvo(
          id: '',
          createdBy: user,
          startAt: formBloc.startAtFB.value!.toDateTime(day),
          endAt: formBloc.endAtFB.value!.toDateTime(day),
          note: formBloc.noteFB.value,
          isPaid: false,
        );
        break;
      case EventCalendarType.vacation:
        event = VacationEventCalendarDvo(
          id: '',
          createdBy: user,
          startAt: formBloc.startAtFB.value!.toDateTime(day),
          endAt: formBloc.endAtFB.value!.toDateTime(day),
          note: formBloc.noteFB.value,
          isPaid: false,
        );
        break;
    }

    await trigger.save(event);
  });
});

class _EventFormBloc extends GroupFieldBloc {
  ProviderSubscription? _projectsSub;

  final EventCalendarType type;

  final startAtFB = InputFieldBloc<TimeOfDay?, void>(
    initialValue: null,
  );
  final endAtFB = InputFieldBloc<TimeOfDay?, void>(
    initialValue: null,
  );
  final noteFB = TextFieldBloc();

  /// Fields for [EventCalendarType.work]

  final clientFB = SelectFieldBloc<ClientDvo, void>(
    validators: [FieldBlocValidators.required],
  );
  final projectFB = SelectFieldBloc<ProjectDvo, void>(
    validators: [FieldBlocValidators.required],
  );

  _EventFormBloc({
    required Ref ref,
    required this.type,
    required DateTime day,
  }) {
    startAtFB.updateInitialValue(TimeOfDay.fromDateTime(day.copyWith(hour: 9)));
    endAtFB.updateInitialValue(TimeOfDay.fromDateTime(day.copyWith(hour: 9 + 4)));

    addAll({
      'startAt': startAtFB,
      'endAt': endAtFB,
      'note': noteFB,
    });

    switch (type) {
      case EventCalendarType.work:
        clientFB.hotStream.distinct((prev, curr) => prev.value == curr.value).listen((state) {
          final client = state.value;
          if (client == null) return;
          _projectsSub?.close();
          _projectsSub = ref.listenFuture<List<ProjectDvo>>(ProjectsTrigger.all(client.id).future,
              fireImmediately: true, (previous, next) {
            projectFB.updateItems(next);
          });
        });

        ref.listenFuture<List<ClientDvo>>(ClientsTrigger.all.future, (previous, next) {
          clientFB.updateItems(next);
        }, fireImmediately: true);

        addAll({
          'client': clientFB,
          'project': projectFB,
        });
        break;
      case EventCalendarType.holiday:
      case EventCalendarType.vacation:
        break;
    }
  }
}

enum EventCalendarType { work, holiday, vacation }

class WorkEventScreen extends ConsumerWidget {
  final EventCalendarType type;
  final DateTime day;

  const WorkEventScreen({
    Key? key,
    required this.type,
    required this.day,
  }) : super(key: key);

  Tuple2<EventCalendarType, DateTime> get args => Tuple2(type, day);

  void save(WidgetRef ref) {
    ref.read(_save(args).bloc).maybeMutate(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formBloc = ref.watch(_form(args).bloc);

    ref.listen<MutationState>(_save(args), (previous, next) {
      next.whenOrNull(success: (_) {
        context.hub.pop();
      });
    });

    List<Widget> buildFields() {
      return [
        TimeFieldBlocBuilder(
          timeFieldBloc: formBloc.startAtFB,
          format: DateFormat.Hm(),
          initialTime: TimeOfDay.fromDateTime(day),
          decoration: const InputDecoration(
            labelText: 'Start At',
          ),
        ),
        TimeFieldBlocBuilder(
          timeFieldBloc: formBloc.endAtFB,
          format: DateFormat.Hm(),
          initialTime: TimeOfDay.fromDateTime(day),
          decoration: const InputDecoration(
            labelText: 'End At',
          ),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.noteFB,
          decoration: const InputDecoration(
            labelText: 'Note',
          ),
        ),
        DropdownFieldBlocBuilder<ClientDvo>(
          selectFieldBloc: formBloc.clientFB,
          showEmptyItem: false,
          decoration: const InputDecoration(
            labelText: 'Client',
          ),
          itemBuilder: (context, value) => FieldItem(child: Text(value.displayName)),
        ),
        DropdownFieldBlocBuilder<ProjectDvo>(
          selectFieldBloc: formBloc.projectFB,
          showEmptyItem: false,
          decoration: const InputDecoration(
            labelText: 'Project',
          ),
          itemBuilder: (context, value) => FieldItem(child: Text(value.name)),
        ),
      ];
    }

    final buttonBar = Consumer(
      builder: (context, ref, _) {
        final canSave = ref.watch(_save(args).select((state) => !state.isMutating));
        final canSubmit = ref.watch(_form(args).select((state) {
          return state.isValid && !state.isValidating;
        }));

        return AppFloatingActionButton(
          onPressed: canSave && canSubmit ? () => save(ref) : null,
          icon: const Icon(Icons.check),
          label: const Text('Save'),
          // child: const Icon(Icons.check),
        );
      },
    );

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: FormBlocProvider(
          formBloc: formBloc,
          child: Column(
            children: buildFields(),
          ),
        ),
      ),
      floatingActionButton: buttonBar,
    );
  }
}
