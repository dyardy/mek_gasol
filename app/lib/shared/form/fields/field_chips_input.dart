import 'package:chips_input/chips_input.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';
import 'package:mek_gasol/shared/form/form_utils.dart';

class FieldChipsInput<T extends Object> extends StatelessWidget {
  final FieldBlocRule<List<T>> fieldBloc;

  final InputDecoration decoration;
  final ChipsInputSuggestions<T> findSuggestions;
  final ChipsBuilder<T>? chipBuilder;
  final Widget Function(BuildContext context, T value)? suggestionBuilder;

  const FieldChipsInput({
    super.key,
    required this.fieldBloc,
    this.decoration = const InputDecoration(),
    required this.findSuggestions,
    this.chipBuilder,
    this.suggestionBuilder,
  });

  Widget _buildSuggestions(BuildContext context, ValueSetter<T> select, Iterable<T> suggestions) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: suggestions.map((e) {
                if (suggestionBuilder != null) {
                  return InkWell(
                    onTap: () => select(e),
                    child: suggestionBuilder!(context, e),
                  );
                }
                return ListTile(
                  onTap: () => select(e),
                  title: Text('$e'),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, ChipsInputState<T> state, T value) {
    if (chipBuilder != null) return chipBuilder!(context, state, value);

    return Chip(
      onDeleted: () => state.deleteChip(value),
      label: Text('$value'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: fieldBloc,
      builder: (context, state) {
        return ChipsInput<T>(
          enabled: state.isEnabled,
          onChanged: fieldBloc.changeValue,
          decoration: decoration.copyWith(errorText: state.widgetError(context)),
          initialValue: state.value,
          findSuggestions: findSuggestions,
          chipBuilder: _buildChip,
          optionsViewBuilder: _buildSuggestions,
        );
      },
    );
  }
}
