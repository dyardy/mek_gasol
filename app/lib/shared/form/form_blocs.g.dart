// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_blocs.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$FieldBlocStateBase<TValue> {
  FieldBlocStateBase<TValue> get _self => this as FieldBlocStateBase<TValue>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$FieldBlocStateBase<TValue> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('FieldBlocStateBase', [TValue])).toString();

  FieldBlocStateBase<TValue> change(void Function(_FieldBlocStateBaseChanges<TValue> c) updates);

  _FieldBlocStateBaseChanges<TValue> toChanges();
}

abstract class _FieldBlocStateBaseChanges<TValue> {
  _FieldBlocStateBaseChanges._(FieldBlocStateBase<TValue> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_FieldBlocStateBaseChanges<TValue> c) updates);

  void replace(covariant FieldBlocStateBase<TValue> dataClass);

  FieldBlocStateBase<TValue> build();
}

mixin _$FieldBlocState<TValue> {
  FieldBlocState<TValue> get _self => this as FieldBlocState<TValue>;

  Iterable<Object?> get _props sync* {
    yield _self.isEnabled;
    yield _self.initialValue;
    yield _self.value;
    yield _self.isChanged;
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
        ..add('initialValue', _self.initialValue)
        ..add('value', _self.value)
        ..add('isChanged', _self.isChanged)
        ..add('errors', _self.errors))
      .toString();

  FieldBlocState<TValue> change(void Function(_FieldBlocStateChanges<TValue> c) updates) =>
      (_FieldBlocStateChanges<TValue>._(_self)..update(updates)).build();

  _FieldBlocStateChanges<TValue> toChanges() => _FieldBlocStateChanges._(_self);
}

class _FieldBlocStateChanges<TValue> implements _FieldBlocStateBaseChanges<TValue> {
  late bool isEnabled;
  late TValue initialValue;
  late TValue value;
  late bool isChanged;
  late List<Object> errors;

  _FieldBlocStateChanges._(FieldBlocState<TValue> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_FieldBlocStateChanges<TValue> c) updates) => updates(this);

  void replace(covariant FieldBlocState<TValue> dataClass) {
    isEnabled = dataClass.isEnabled;
    initialValue = dataClass.initialValue;
    value = dataClass.value;
    isChanged = dataClass.isChanged;
    errors = dataClass.errors;
  }

  FieldBlocState<TValue> build() => FieldBlocState(
        isEnabled: isEnabled,
        initialValue: initialValue,
        value: value,
        isChanged: isChanged,
        errors: errors,
      );
}

mixin _$ListFieldBlocState<TValue> {
  ListFieldBlocState<TValue> get _self => this as ListFieldBlocState<TValue>;

  Iterable<Object?> get _props sync* {
    yield _self.fieldBlocs;
    yield _self.fieldStates;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ListFieldBlocState<TValue> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('ListFieldBlocState', [TValue])
        ..add('fieldBlocs', _self.fieldBlocs)
        ..add('fieldStates', _self.fieldStates))
      .toString();

  ListFieldBlocState<TValue> change(void Function(_ListFieldBlocStateChanges<TValue> c) updates) =>
      (_ListFieldBlocStateChanges<TValue>._(_self)..update(updates)).build();

  _ListFieldBlocStateChanges<TValue> toChanges() => _ListFieldBlocStateChanges._(_self);
}

class _ListFieldBlocStateChanges<TValue> implements _FieldBlocStateBaseChanges<List<TValue>> {
  late List<FieldBlocBase<FieldBlocStateBase<TValue>, TValue>> fieldBlocs;
  late List<FieldBlocStateBase<TValue>> fieldStates;

  _ListFieldBlocStateChanges._(ListFieldBlocState<TValue> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_ListFieldBlocStateChanges<TValue> c) updates) => updates(this);

  void replace(covariant ListFieldBlocState<TValue> dataClass) {
    fieldBlocs = dataClass.fieldBlocs;
    fieldStates = dataClass.fieldStates;
  }

  ListFieldBlocState<TValue> build() => ListFieldBlocState(
        fieldBlocs: fieldBlocs,
        fieldStates: fieldStates,
      );
}

mixin _$MapFieldBlocState<TKey, TValue> {
  MapFieldBlocState<TKey, TValue> get _self => this as MapFieldBlocState<TKey, TValue>;

  Iterable<Object?> get _props sync* {
    yield _self.fieldBlocs;
    yield _self.fieldStates;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$MapFieldBlocState<TKey, TValue> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('MapFieldBlocState', [TKey, TValue])
        ..add('fieldBlocs', _self.fieldBlocs)
        ..add('fieldStates', _self.fieldStates))
      .toString();

  MapFieldBlocState<TKey, TValue> change(
          void Function(_MapFieldBlocStateChanges<TKey, TValue> c) updates) =>
      (_MapFieldBlocStateChanges<TKey, TValue>._(_self)..update(updates)).build();

  _MapFieldBlocStateChanges<TKey, TValue> toChanges() => _MapFieldBlocStateChanges._(_self);
}

class _MapFieldBlocStateChanges<TKey, TValue>
    implements _FieldBlocStateBaseChanges<Map<TKey, TValue>> {
  late Map<TKey, FieldBlocBase<FieldBlocStateBase<TValue>, TValue>> fieldBlocs;
  late Map<TKey, FieldBlocStateBase<TValue>> fieldStates;

  _MapFieldBlocStateChanges._(MapFieldBlocState<TKey, TValue> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_MapFieldBlocStateChanges<TKey, TValue> c) updates) => updates(this);

  void replace(covariant MapFieldBlocState<TKey, TValue> dataClass) {
    fieldBlocs = dataClass.fieldBlocs;
    fieldStates = dataClass.fieldStates;
  }

  MapFieldBlocState<TKey, TValue> build() => MapFieldBlocState(
        fieldBlocs: fieldBlocs,
        fieldStates: fieldStates,
      );
}
