import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/eti/features/calendar_rules/dto/calendar_rule_dto.dart';
import 'package:mek_gasol/modules/eti/features/calendar_rules/triggers/rules_calendar_trigger.dart';
import 'package:mek_gasol/shared/flutter_utils.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/rivertion.dart';

final _form = BlocProvider.autoDispose((ref) {
  return _EventFormBloc(ref: ref);
});

final _save = MutationProvider.autoDispose((ref) {
  return MutationBloc((param) async {
    final trigger = ref.read(RulesCalendarTrigger.instance);
    final formBloc = ref.read(_form.bloc);

    await trigger.save(WorkRuleCalendarDto(
      id: '',
      startAt: formBloc.startAtFB.value!.toDuration(),
      endAt: formBloc.endAtFB.value!.toDuration(),
      weekDays: formBloc.weekDays.value.toBuiltList(),
    ));
  });
});

class _EventFormBloc extends GroupFieldBloc {
  final startAtFB = InputFieldBloc<TimeOfDay?, void>(
    initialValue: null,
  );
  final endAtFB = InputFieldBloc<TimeOfDay?, void>(
    initialValue: null,
  );
  final weekDays = MultiSelectFieldBloc<WeekDay, void>(
    validators: [FieldBlocValidators.required],
    items: WeekDay.values,
  );

  _EventFormBloc({required Ref ref}) {
    startAtFB.updateInitialValue(TimeOfDay.now());
    endAtFB.updateInitialValue(TimeOfDay.now());

    addAll({
      'startAt': startAtFB,
      'endAt': endAtFB,
      'weekDays': weekDays,
    });
  }
}

class CalendarRuleScreen extends ConsumerWidget {
  const CalendarRuleScreen({Key? key}) : super(key: key);

  void save(WidgetRef ref) {
    ref.read(_save.bloc).maybeMutate(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formBloc = ref.watch(_form.bloc);

    ref.listen<MutationState>(_save, (previous, next) {
      next.whenOrNull(success: (_) {
        context.hub.pop();
      });
    });

    List<Widget> buildFields() {
      return [
        TimeFieldBlocBuilder(
          timeFieldBloc: formBloc.startAtFB,
          format: DateFormat.Hm(),
          initialTime: TimeOfDay.now(),
          decoration: const InputDecoration(
            labelText: 'Start At',
          ),
        ),
        TimeFieldBlocBuilder(
          timeFieldBloc: formBloc.endAtFB,
          format: DateFormat.Hm(),
          initialTime: TimeOfDay.now(),
          decoration: const InputDecoration(
            labelText: 'End At',
          ),
        ),
        FilterChipFieldBlocBuilder<WeekDay>(
          multiSelectFieldBloc: formBloc.weekDays,
          decoration: const InputDecoration(
            labelText: 'Week Days',
          ),
          itemBuilder: (context, value) => ChipFieldItem(label: Text(value.name)),
        ),
      ];
    }

    final buttonBar = Consumer(
      builder: (context, ref, _) {
        final canSave = ref.watch(_save.select((state) => !state.isMutating));
        final canSubmit = ref.watch(_form.select((state) {
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
