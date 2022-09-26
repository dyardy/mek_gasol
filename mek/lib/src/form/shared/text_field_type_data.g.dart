// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_field_type_data.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$TextFieldTypeData {
  TextFieldTypeData get _self => this as TextFieldTypeData;

  Iterable<Object?> get _props sync* {
    yield _self.keyboardType;
    yield _self.inputFormatters;
    yield _self.obscureText;
    yield _self.enableSuggestions;
    yield _self.autocorrect;
    yield _self.decoration;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$TextFieldTypeData &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('TextFieldTypeData')
        ..add('keyboardType', _self.keyboardType)
        ..add('inputFormatters', _self.inputFormatters)
        ..add('obscureText', _self.obscureText)
        ..add('enableSuggestions', _self.enableSuggestions)
        ..add('autocorrect', _self.autocorrect)
        ..add('decoration', _self.decoration))
      .toString();

  TextFieldTypeData copyWith({
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool? obscureText,
    bool? enableSuggestions,
    bool? autocorrect,
    InputDecoration? decoration,
  }) {
    return TextFieldTypeData(
      keyboardType: keyboardType ?? _self.keyboardType,
      inputFormatters: inputFormatters ?? _self.inputFormatters,
      obscureText: obscureText ?? _self.obscureText,
      enableSuggestions: enableSuggestions ?? _self.enableSuggestions,
      autocorrect: autocorrect ?? _self.autocorrect,
      decoration: decoration ?? _self.decoration,
    );
  }
}
