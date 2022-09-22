import 'package:flutter/material.dart';
import 'package:mek/src/bloc/bloc_consumers.dart';
import 'package:mek/src/form/blocs/field_bloc.dart';
import 'package:mek/src/form/form_utils.dart';

class FieldTime<T extends TimeOfDay?> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocBuilder<FieldBlocStateBase<T>>(
      bloc: fieldBloc,
      builder: (context, state) {
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
      },
    );
  }
}
