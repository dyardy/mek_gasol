import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';
import 'package:mek_gasol/shared/form/form_utils.dart';

abstract class FieldConvert<T> {
  const FieldConvert();

  T? toValue(String text);

  String toText(T? value);

  static const FieldConvert<String> text = _TextFieldConverter();
  static const FieldConvert<int> integer = _IntFieldConvert();
  static const FieldConvert<Decimal> decimal = _DecimalFieldConvert();
}

class _TextFieldConverter extends FieldConvert<String> {
  const _TextFieldConverter();

  @override
  String? toValue(String text) => text;

  @override
  String toText(String? value) => value ?? '';
}

class _IntFieldConvert extends FieldConvert<int> {
  const _IntFieldConvert();

  @override
  int? toValue(String text) => int.tryParse(text);

  @override
  String toText(int? value) => value?.toString() ?? '';
}

class _DecimalFieldConvert extends FieldConvert<Decimal> {
  const _DecimalFieldConvert();

  @override
  Decimal? toValue(String text) => Decimal.tryParse(text);

  @override
  String toText(Decimal? value) => value?.toString() ?? '';
}

class FieldText<T> extends StatefulWidget {
  final FieldBlocRule<T> fieldBloc;
  final FieldConvert<T> converter;
  final TextFieldType type;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final InputDecoration decoration;

  const FieldText({
    Key? key,
    required this.fieldBloc,
    required this.converter,
    this.type = const TextFieldType(),
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.decoration = const InputDecoration(),
  }) : super(key: key);

  @override
  State<FieldText<T>> createState() => _TextFieldBuilderState();
}

class _TextFieldBuilderState<T> extends State<FieldText<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.converter.toText(widget.fieldBloc.state.value),
    );
  }

  @override
  void didUpdateWidget(covariant FieldText<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fieldBloc != oldWidget.fieldBloc) {
      _controller.dispose();
      _controller = TextEditingController(
        text: widget.converter.toText(widget.fieldBloc.state.value),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FieldBlocStateBase<T>>(
      bloc: widget.fieldBloc,
      listener: (context, state) {
        final fieldValue = widget.converter.toValue(_controller.text);
        if (fieldValue == state.value) return;
        _controller.text = widget.converter.toText(state.value);
      },
      builder: (context, state) {
        return TextField(
          controller: _controller,
          onChanged: (text) {
            final value = widget.converter.toValue(text);
            if (value is T) widget.fieldBloc.changeValue(value);
          },
          enabled: state.isEnabled,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          keyboardType: widget.keyboardType ?? widget.type.getKeyboardType(),
          inputFormatters: widget.type.getInputFormatters(),
          decoration: widget.decoration.copyWith(errorText: state.widgetError(context)),
        );
      },
    );
  }
}
