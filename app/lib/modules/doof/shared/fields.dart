import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppTextField extends StatelessWidget {
  final FormControl<String> formControl;
  final InputDecoration decoration;

  const AppTextField({
    super.key,
    required this.formControl,
    this.decoration = const InputDecoration(),
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      formControl: formControl,
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
      decoration: widget.decoration,
    );
  }
}

class _DecimalValueAccessor extends ControlValueAccessor<Decimal, String> {
  @override
  String? modelToViewValue(Decimal? modelValue) => modelValue?.toString();

  @override
  Decimal? viewToModelValue(String? viewValue) => Decimal.tryParse(viewValue ?? '');
}
