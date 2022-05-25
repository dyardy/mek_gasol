import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:mek_gasol/modules/eti/features/clients/triggers/clients_trigger.dart';
import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';
import 'package:mek_gasol/modules/eti/features/projects/triggers/projects_trigger.dart';
import 'package:mek_gasol/modules/eti/features/work_events/dvo/work_event_dvo.dart';
import 'package:mek_gasol/modules/eti/features/work_events/triggers/work_event_trigger.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/flutter_utils.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:mek_gasol/shared/riverpod_extensions.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';
import 'package:pure_extensions/pure_extensions.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/rivertion.dart';

abstract class WorkEventBloc {
  static final form =
      BlocProvider.family.autoDispose<WorkEventFormBloc, GroupFieldBlocState, DateTime>((ref, day) {
    return WorkEventFormBloc(
      ref: ref,
      day: day,
    );
  });

  static final save = MutationProvider.family.autoDispose((ref, DateTime day) {
    return MutationBloc((param) async {
      final trigger = ref.read(WorkEventTrigger.instance);
      final formBloc = ref.read(form(day).bloc);
      final user = await ref.read(Providers.user.future);

      await trigger.save(WorkEventDvo(
        id: '',
        creatorUser: user,
        client: formBloc.clientFB.value!,
        project: formBloc.projectFB.value!,
        startAt: formBloc.startAtFB.value!.toDateTime(day),
        endAt: formBloc.endAtFB.value!.toDateTime(day),
        note: formBloc.noteFB.value,
      ));
    });
  });
}

class WorkEventFormBloc extends GroupFieldBloc {
  ProviderSubscription? _projectsSub;

  final clientFB = SelectFieldBloc<ClientDvo, void>(
    validators: [FieldBlocValidators.required],
  );
  final projectFB = SelectFieldBloc<ProjectDvo, void>(
    validators: [FieldBlocValidators.required],
  );
  final startAtFB = InputFieldBloc<TimeOfDay?, void>(
    initialValue: null,
  );
  final endAtFB = InputFieldBloc<TimeOfDay?, void>(
    initialValue: null,
  );
  final noteFB = TextFieldBloc();

  WorkEventFormBloc({
    required Ref ref,
    required DateTime day,
  }) {
    clientFB.hotStream.distinct((prev, curr) => prev.value == curr.value).listen((state) {
      final client = state.value;
      if (client == null) return;
      _projectsSub?.close();
      _projectsSub = ref.listenFuture<BuiltList<ProjectDvo>>(ProjectsTrigger.all(client.id).future,
          fireImmediately: true, (previous, next) {
        projectFB.updateItems(next.asList());
      });
    });

    ref.listenFuture<BuiltList<ClientDvo>>(ClientsTrigger.all.future, (previous, next) {
      clientFB.updateItems(next.asList());
    }, fireImmediately: true);

    startAtFB.updateInitialValue(TimeOfDay.fromDateTime(day.copyWith(hour: 9)));
    endAtFB.updateInitialValue(TimeOfDay.fromDateTime(day.copyWith(hour: 9 + 4)));

    addAll({
      'client': clientFB,
      'project': projectFB,
      'startAt': startAtFB,
      'endAt': endAtFB,
      'note': noteFB,
    });
  }
}

class WorkEventScreen extends ConsumerWidget {
  final DateTime day;

  const WorkEventScreen({
    Key? key,
    required this.day,
  }) : super(key: key);

  void save(WidgetRef ref) {
    ref.read(WorkEventBloc.save(day).bloc).maybeMutate(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formBloc = ref.watch(WorkEventBloc.form(day).bloc);

    ref.listen<MutationState>(WorkEventBloc.save(day), (previous, next) {
      next.whenOrNull(success: (_) {
        Hub.pop();
      });
    });

    List<Widget> _buildFields() {
      return [
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
      ];
    }

    final buttonBar = Consumer(
      builder: (context, ref, _) {
        final canSave = ref.watch(WorkEventBloc.save(day).select((state) => !state.isMutating));
        final canSubmit = ref.watch(WorkEventBloc.form(day).select((state) {
          return !state.hasUpdatedValue && !state.isValidating;
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
        child: Column(
          children: _buildFields(),
        ),
      ),
      floatingActionButton: buttonBar,
    );
  }
}
