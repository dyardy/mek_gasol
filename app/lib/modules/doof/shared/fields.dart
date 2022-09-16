import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppTextField extends StatelessWidget {
  final FormControl<String> formControl;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final InputDecoration decoration;

  const AppTextField({
    super.key,
    required this.formControl,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.decoration = const InputDecoration(),
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      formControl: formControl,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      decoration: decoration,
    );
  }
}

class AppDecimalField extends StatefulWidget {
  final FormControl<Decimal> formControl;
  final InputDecoration decoration;

  const AppDecimalField({
    super.key,
    required this.formControl,
    this.decoration = const InputDecoration(),
  });

  @override
  State<AppDecimalField> createState() => _AppDecimalFieldState();
}

class _AppDecimalFieldState extends State<AppDecimalField> {
  final valueAccessor = _DecimalValueAccessor();

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      formControl: widget.formControl,
      valueAccessor: valueAccessor,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: const [_DecimalInputFormatter()],
      decoration: widget.decoration,
    );
  }
}

class _DecimalInputFormatter with TextInputFormatter {
  const _DecimalInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regExp = RegExp(r'^\d*\.?\d*$');
    return regExp.hasMatch(newValue.text) ? newValue : oldValue;
  }
}

class _DecimalValueAccessor extends ControlValueAccessor<Decimal, String> {
  @override
  String? modelToViewValue(Decimal? modelValue) => modelValue?.toString();

  @override
  Decimal? viewToModelValue(String? viewValue) => Decimal.tryParse(viewValue ?? '');
}
