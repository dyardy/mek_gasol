import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';
import 'package:mek_gasol/shared/form/form_utils.dart';

class FieldDropdown<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: fieldBloc,
      builder: (context, state) {
        return DropdownButtonFormField<T>(
          value: state.value,
          onChanged: state.getIfEnabled((value) => fieldBloc.changeValue(value as T)),
          items: items,
          decoration: decoration,
        );
      },
    );
  }
}
