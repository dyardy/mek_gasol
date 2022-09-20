// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_field_bloc.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

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

class _ListFieldBlocStateChanges<TValue> {
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
