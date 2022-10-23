import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mek/src/consumer/mixed_consumer.dart';
import 'package:mek/src/consumer/source_extensions.dart';
import 'package:mek/src/form/blocs/field_bloc.dart';
import 'package:mek/src/form/form_utils.dart';
import 'package:mek/src/form/shared/text_field_type_data.dart';

class FieldText<T> extends ConsumerStatefulWidget {
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
  ConsumerState<FieldText<T>> createState() => FieldTextState();
}

class FieldTextState<T> extends ConsumerState<FieldText<T>> {
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
    ref.observe(widget.fieldBloc.toSource(), (state) {
      final fieldValue = widget.converter.toValue(_controller.text);
      if (fieldValue == state.value) return;
      _controller.text = widget.converter.toText(state.value);
    });

    final state = ref.react(widget.fieldBloc.toSource());

    final field = Builder(builder: (context) {
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
    });

    return TextFieldScope(
      decoration: widget.decoration,
      typeData: _typeData,
      child: field,
    );
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

abstract class TextFieldType {
  const TextFieldType();

  static const TextFieldType none = _NoneTextFieldType();

  const factory TextFieldType.numeric({bool signed, bool decimal}) = _NumericTextFieldType;
  const factory TextFieldType.email() = _EmailTextFieldType;
  const factory TextFieldType.password() = _PasswordTextFieldType;
  const factory TextFieldType.phone() = _PhoneTextFieldType;

  TextFieldTypeData resolve(BuildContext context);

  TextFieldTypeData? build(BuildContext context) => null;
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

class _NoneTextFieldType extends TextFieldType {
  const _NoneTextFieldType();

  @override
  TextFieldTypeData resolve(BuildContext context) => const TextFieldTypeData();
}

class _NumericTextFieldType extends TextFieldType {
  final bool signed;
  final bool decimal;

  const _NumericTextFieldType({
    this.signed = false,
    this.decimal = false,
  });

  @override
  TextFieldTypeData resolve(BuildContext context) {
    return TextFieldTypeData(
      keyboardType: TextInputType.numberWithOptions(signed: signed, decimal: decimal),
      inputFormatters: [_NumericTextInputFormatter(signed: signed, decimal: decimal)],
    );
  }
}

class _NumericTextInputFormatter implements TextInputFormatter {
  final bool signed;
  final bool decimal;

  const _NumericTextInputFormatter({
    this.signed = false,
    this.decimal = false,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final b = StringBuffer(r'^');
    if (signed) b.write(r'-?');
    b.write(r'\d*');
    if (decimal) b.write(r'\.?\d*');
    b.write(r'$');
    final regExp = RegExp(b.toString());

    return regExp.hasMatch(newValue.text) ? newValue : oldValue;
  }
}

class _EmailTextFieldType extends TextFieldType {
  const _EmailTextFieldType();

  @override
  TextFieldTypeData resolve(BuildContext context) {
    return TextFieldTypeData(
      inputFormatters: [
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.deny(' ')
      ],
    );
  }
}

class _PasswordTextFieldType extends TextFieldType {
  const _PasswordTextFieldType();

  @override
  TextFieldTypeData resolve(BuildContext context) {
    return TextFieldTypeData(
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      inputFormatters: [
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.deny(' ')
      ],
    );
  }

  @override
  TextFieldTypeData build(BuildContext context) {
    final scope = TextFieldScope.of(context);
    final typeData = scope.typeData;

    return typeData.copyWith(
      decoration: scope.decoration.copyWith(
        suffixIcon: IconButton(
          onPressed: () => FieldText.of(context).update(typeData.copyWith(
            obscureText: !typeData.obscureText,
          )),
          icon: typeData.obscureText
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ),
      ),
    );
  }
}

class _PhoneTextFieldType extends TextFieldType {
  const _PhoneTextFieldType();

  @override
  TextFieldTypeData resolve(BuildContext context) {
    return TextFieldTypeData(
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+\d]'))],
    );
  }
}
