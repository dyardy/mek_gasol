import 'package:flutter/material.dart';
import 'package:mek/src/consumer/mixed_consumer.dart';
import 'package:mek/src/consumer/source_extensions.dart';
import 'package:mek/src/form/blocs/field_bloc.dart';
import 'package:mek/src/form/form_utils.dart';

class FieldTime<T extends TimeOfDay?> extends ConsumerWidget {
  final FieldBlocRule<T> fieldBloc;

  final InputDecoration decoration;

  /// Default: [TimeOfDay.now]
  final TimeOfDay? initialTime;

  const FieldTime({
    Key? key,
    required this.fieldBloc,
    this.decoration = const InputDecoration(),
    this.initialTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.react(fieldBloc.toSource());

    return InputDecorator(
      decoration: decoration.copyWith(errorText: state.widgetError(context)),
      isEmpty: state.value == null,
      child: InkWell(
        onTap: state.ifEnabled(() async {
          final value = await showTimePicker(
            context: context,
            initialTime: initialTime ?? TimeOfDay.now(),
          );
          if (value == null) return;
          fieldBloc.updateValue(value as T);
        }),
        child: Text(state.value?.format(context) ?? ''),
      ),
    );
  }
}
