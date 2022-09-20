// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_field_bloc.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

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

class _MapFieldBlocStateChanges<TKey, TValue> {
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
