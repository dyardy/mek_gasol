import 'package:flutter/material.dart';
import 'package:mek/src/consumer/mixed_consumer.dart';
import 'package:mek/src/consumer/source_extensions.dart';
import 'package:mek/src/form/blocs/field_bloc.dart';
import 'package:mek/src/form/form_utils.dart';

class FieldSlider extends ConsumerWidget {
  final FieldBlocRule<double> fieldBloc;
  final double min;
  final double max;
  final int? divisions;
  final InputDecoration decoration;
  final String Function(double value)? labelBuilder;

  const FieldSlider({
    Key? key,
    required this.fieldBloc,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.decoration = const InputDecoration(),
    this.labelBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.react(fieldBloc.toSource());

    return InputDecorator(
      decoration: decoration.copyWith(errorText: state.widgetError(context)),
      child: Slider(
        value: state.value,
        onChanged: state.ifEnabled(fieldBloc.changeValue),
        min: min,
        max: max,
        divisions: divisions,
        label: labelBuilder?.call(state.value),
      ),
    );
  }
}
