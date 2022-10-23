import 'package:flutter/material.dart';
import 'package:mek/src/consumer/mixed_consumer.dart';
import 'package:mek/src/consumer/source_extensions.dart';
import 'package:mek/src/form/blocs/field_bloc.dart';
import 'package:mek/src/form/form_utils.dart';

class FieldDropdown<T> extends ConsumerWidget {
  final FieldBlocRule<T> fieldBloc;

  final InputDecoration decoration;
  final List<DropdownMenuItem<T>> items;

  const FieldDropdown({
    Key? key,
    required this.fieldBloc,
    this.decoration = const InputDecoration(),
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.react(fieldBloc.toSource());

    return DropdownButtonFormField<T>(
      value: state.value,
      onChanged: state.ifEnabled((value) => fieldBloc.changeValue(value as T)),
      items: items,
      decoration: decoration.copyWith(errorText: state.widgetError(context)),
    );
  }
}
