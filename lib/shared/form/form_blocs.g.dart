// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_blocs.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$FieldBlocState<TValue> {
  FieldBlocStateBase<TValue> get _self => this as FieldBlocStateBase<TValue>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$FieldBlocState<TValue> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('FieldBlocState', [TValue])).toString();

  FieldBlocStateBase<TValue> change(void Function(_FieldBlocStateChanges<TValue> c) updates);

  _FieldBlocStateChanges<TValue> toChanges();
}

abstract class _FieldBlocStateChanges<TValue> {
  _FieldBlocStateChanges._(FieldBlocStateBase<TValue> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_FieldBlocStateChanges<TValue> c) updates);

  void replace(covariant FieldBlocStateBase<TValue> dataClass);

  FieldBlocStateBase<TValue> build();
}

mixin _$SingleFieldBlocState<TValue> {
  FieldBlocState<TValue> get _self => this as FieldBlocState<TValue>;

  Iterable<Object?> get _props sync* {
    yield _self.value;
    yield _self.error;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$SingleFieldBlocState<TValue> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('SingleFieldBlocState', [TValue])
        ..add('value', _self.value)
        ..add('error', _self.error))
      .toString();

  FieldBlocState<TValue> change(void Function(_SingleFieldBlocStateChanges<TValue> c) updates) =>
      (_SingleFieldBlocStateChanges<TValue>._(_self)..update(updates)).build();

  _SingleFieldBlocStateChanges<TValue> toChanges() => _SingleFieldBlocStateChanges._(_self);
}

class _SingleFieldBlocStateChanges<TValue> implements _FieldBlocStateChanges<TValue> {
  late TValue value;
  late Object? error;

  _SingleFieldBlocStateChanges._(FieldBlocState<TValue> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_SingleFieldBlocStateChanges<TValue> c) updates) => updates(this);

  void replace(covariant FieldBlocState<TValue> dataClass) {
    value = dataClass.value;
    error = dataClass.error;
  }

  FieldBlocState<TValue> build() => FieldBlocState(
        value: value,
        error: error,
      );
}

mixin _$ListFieldBlocState<TValue> {
  ListFieldBlocState<TValue> get _self => this as ListFieldBlocState<TValue>;

  Iterable<Object?> get _props sync* {
    yield _self.fieldBlocs;
    yield _self.value;
    yield _self.isValid;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ListFieldBlocState<TValue> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('ListFieldBlocState', [TValue])
        ..add('fieldBlocs', _self.fieldBlocs)
        ..add('value', _self.value)
        ..add('isValid', _self.isValid))
      .toString();

  ListFieldBlocState<TValue> change(void Function(_ListFieldBlocStateChanges<TValue> c) updates) =>
      (_ListFieldBlocStateChanges<TValue>._(_self)..update(updates)).build();

  _ListFieldBlocStateChanges<TValue> toChanges() => _ListFieldBlocStateChanges._(_self);
}

class _ListFieldBlocStateChanges<TValue> implements _FieldBlocStateChanges<List<TValue>> {
  late List<FieldBlocBase<FieldBlocStateBase<TValue>, TValue>> fieldBlocs;
  late List<TValue> value;
  late bool isValid;

  _ListFieldBlocStateChanges._(ListFieldBlocState<TValue> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_ListFieldBlocStateChanges<TValue> c) updates) => updates(this);

  void replace(covariant ListFieldBlocState<TValue> dataClass) {
    fieldBlocs = dataClass.fieldBlocs;
    value = dataClass.value;
    isValid = dataClass.isValid;
  }

  ListFieldBlocState<TValue> build() => ListFieldBlocState(
        fieldBlocs: fieldBlocs,
        value: value,
        isValid: isValid,
      );
}
