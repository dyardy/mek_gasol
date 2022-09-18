import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mek_gasol/shared/form/fields/field_text.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';

extension FieldBlocStateBaseExtensions<TValue> on FieldBlocStateBase<TValue> {
  String? widgetError(BuildContext context) {
    return isInvalid && isTouched ? '${errors.first}' : null;
  }

  R? ifEnabled<R>(R result) {
    return isEnabled ? result : null;
  }
}

extension ListFieldBlocBaseExtensions<T> on FieldBlocRule<List<T>> {
  void changeAddingValues(T value) {
    changeValue([...state.value, value]);
  }

  void changeRemovingValues(T value) {
    changeValue([...state.value]..remove(value));
  }
}

extension ListFieldBlocStateBaseExtensions<T> on FieldBlocStateBase<List<T>> {
  ValueChanged<bool?>? widgetSelectHandler(FieldBlocRule<List<T>> fieldBloc, T value) {
    return ifEnabled((isSelected) {
      if (isSelected!) {
        fieldBloc.changeAddingValues(value);
      } else {
        fieldBloc.changeRemovingValues(value);
      }
    });
  }
}

abstract class TextFieldType {
  const TextFieldType();

  static const TextFieldType none = _NoneTextFieldType();

  const factory TextFieldType.numeric({bool signed, bool decimal}) = _NumericTextFieldType;
  const factory TextFieldType.email() = _EmailTextFieldType;
  const factory TextFieldType.password() = _PasswordTextFieldType;

  TextFieldTypeData resolve(BuildContext context);

  TextFieldTypeData? build(BuildContext context) => null;
}

class TextFieldTypeData {
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final InputDecoration? decoration;

  const TextFieldTypeData({
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.decoration,
  });

  TextFieldTypeData copyWith({
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool? obscureText,
    bool? enableSuggestions,
    bool? autocorrect,
    InputDecoration? decoration,
  }) {
    return TextFieldTypeData(
      keyboardType: keyboardType ?? this.keyboardType,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      obscureText: obscureText ?? this.obscureText,
      enableSuggestions: enableSuggestions ?? this.enableSuggestions,
      autocorrect: autocorrect ?? this.autocorrect,
      decoration: decoration ?? this.decoration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextFieldTypeData &&
          runtimeType == other.runtimeType &&
          keyboardType == other.keyboardType &&
          inputFormatters == other.inputFormatters &&
          obscureText == other.obscureText &&
          enableSuggestions == other.enableSuggestions &&
          autocorrect == other.autocorrect &&
          decoration == other.decoration;

  @override
  int get hashCode =>
      keyboardType.hashCode ^
      inputFormatters.hashCode ^
      obscureText.hashCode ^
      enableSuggestions.hashCode ^
      autocorrect.hashCode ^
      decoration.hashCode;
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
