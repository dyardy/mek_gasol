// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_bloc.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$FieldBlocState<TValue> {
  FieldBlocState<TValue> get _self => this as FieldBlocState<TValue>;

  Iterable<Object?> get _props sync* {
    yield _self.isEnabled;
    yield _self.isTouched;
    yield _self.initialValue;
    yield _self.value;
    yield _self.errors;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$FieldBlocState<TValue> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('FieldBlocState', [TValue])
        ..add('isEnabled', _self.isEnabled)
        ..add('isTouched', _self.isTouched)
        ..add('initialValue', _self.initialValue)
        ..add('value', _self.value)
        ..add('errors', _self.errors))
      .toString();

  FieldBlocState<TValue> change(void Function(_FieldBlocStateChanges<TValue> c) updates) =>
      (_FieldBlocStateChanges<TValue>._(_self)..update(updates)).build();

  _FieldBlocStateChanges<TValue> toChanges() => _FieldBlocStateChanges._(_self);
}

class _FieldBlocStateChanges<TValue> {
  late bool isEnabled;
  late bool isTouched;
  late TValue initialValue;
  late TValue value;
  late List<Object> errors;

  _FieldBlocStateChanges._(FieldBlocState<TValue> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_FieldBlocStateChanges<TValue> c) updates) => updates(this);

  void replace(covariant FieldBlocState<TValue> dataClass) {
    isEnabled = dataClass.isEnabled;
    isTouched = dataClass.isTouched;
    initialValue = dataClass.initialValue;
    value = dataClass.value;
    errors = dataClass.errors;
  }

  FieldBlocState<TValue> build() => FieldBlocState(
        isEnabled: isEnabled,
        isTouched: isTouched,
        initialValue: initialValue,
        value: value,
        errors: errors,
      );
}
