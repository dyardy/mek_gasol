import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';
import 'package:mek_gasol/shared/form/form_utils.dart';

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
    this.type = TextFieldType.none,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.decoration = const InputDecoration(),
  }) : super(key: key);

  static FieldTextState of(BuildContext context) {
    return context.findAncestorStateOfType()!;
  }

  @override
  State<FieldText<T>> createState() => FieldTextState();
}

class FieldTextState<T> extends State<FieldText<T>> {
  late TextEditingController _controller;
  late TextFieldTypeData _typeData;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.converter.toText(widget.fieldBloc.state.value),
    );
    _typeData = widget.type.resolve(context);
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
    if (widget.type != oldWidget.type) {
      _typeData = widget.type.resolve(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void update(TextFieldTypeData data) {
    setState(() => _typeData = data);
  }

  @override
  Widget build(BuildContext context) {
    final field = BlocConsumer<FieldBlocStateBase<T>>(
      bloc: widget.fieldBloc,
      listener: (context, state) {
        final fieldValue = widget.converter.toValue(_controller.text);
        if (fieldValue == state.value) return;
        _controller.text = widget.converter.toText(state.value);
      },
      builder: (context, state) {
        final typeData = widget.type.build(context) ?? _typeData;

        return TextField(
          controller: _controller,
          onChanged: (text) {
            final value = widget.converter.toValue(text);
            if (value is T) widget.fieldBloc.changeValue(value);
          },
          enabled: state.isEnabled,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          decoration: (typeData.decoration ?? widget.decoration)
              .copyWith(errorText: state.widgetError(context)),
          obscureText: typeData.obscureText,
          enableSuggestions: typeData.enableSuggestions,
          autocorrect: typeData.autocorrect,
          keyboardType: typeData.keyboardType,
          inputFormatters: typeData.inputFormatters,
        );
      },
    );

    return TextFieldScope(
      decoration: widget.decoration,
      typeData: _typeData,
      child: field,
    );
  }
}

class TextFieldScope extends InheritedWidget {
  final InputDecoration decoration;
  final TextFieldTypeData typeData;

  const TextFieldScope({
    super.key,
    required this.decoration,
    required this.typeData,
    required super.child,
  });

  static TextFieldScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TextFieldScope>()!;
  }

  @override
  bool updateShouldNotify(TextFieldScope oldWidget) {
    return decoration != oldWidget.decoration || typeData != oldWidget.typeData;
  }
}

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
