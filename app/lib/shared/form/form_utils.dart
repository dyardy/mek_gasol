import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';

extension FieldBlocStateBaseExtensions<TValue> on FieldBlocStateBase<TValue> {
  String? widgetError(BuildContext context) {
    return isInvalid && isChanged ? '${errors.first}' : null;
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

class TextFieldType {
  const TextFieldType();

  const factory TextFieldType.numeric({bool signed, bool decimal}) = _NumericTextFieldType;

  TextInputType? getKeyboardType() => null;

  List<TextInputFormatter> getInputFormatters() => const [];
}

class _NumericTextFieldType extends TextFieldType {
  final bool signed;
  final bool decimal;

  const _NumericTextFieldType({
    this.signed = false,
    this.decimal = false,
  });

  @override
  TextInputType? getKeyboardType() =>
      TextInputType.numberWithOptions(signed: signed, decimal: decimal);

  @override
  List<TextInputFormatter> getInputFormatters() =>
      [_NumericTextInputFormatter(signed: signed, decimal: decimal)];
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
