import 'package:flutter/material.dart';
import 'package:mek/src/consumer/mixed_consumer.dart';
import 'package:mek/src/consumer/source_extensions.dart';
import 'package:mek/src/form/blocs/field_bloc.dart';
import 'package:mek/src/form/form_utils.dart';
import 'package:mek/src/form/shared/group_style.dart';
import 'package:mek/src/form/shared/group_view.dart';

class FieldGroupBuilder<T> extends ConsumerWidget {
  final FieldBlocRule<T> fieldBloc;
  final int valuesCount;
  final GroupStyle style;
  final InputDecoration decoration;
  final Widget Function(FieldBlocStateBase<T> state, int index) valueBuilder;

  const FieldGroupBuilder({
    Key? key,
    required this.fieldBloc,
    required this.valuesCount,
    this.style = const FlexGroupStyle(),
    this.decoration = const InputDecoration(),
    required this.valueBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.react(fieldBloc.toSource());

    return InputDecorator(
      decoration: decoration.copyWith(errorText: state.widgetError(context)),
      child: GroupView(
        style: style,
        count: valuesCount,
        builder: (context, index) {
          return valueBuilder(state, index);
        },
      ),
    );
  }
}
