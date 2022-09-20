// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_bloc.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$QueryState<T> {
  QueryState<T> get _self => this as QueryState<T>;

  Iterable<Object?> get _props sync* {
    yield _self.isLoading;
    yield _self.dataOrNull;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$QueryState<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('QueryState', [T])
        ..add('isLoading', _self.isLoading)
        ..add('dataOrNull', _self.dataOrNull))
      .toString();

  QueryState<T> change(void Function(_QueryStateChanges<T> c) updates) =>
      (_QueryStateChanges<T>._(_self)..update(updates)).build();

  _QueryStateChanges<T> toChanges() => _QueryStateChanges._(_self);
}

class _QueryStateChanges<T> {
  late bool isLoading;
  late T? dataOrNull;

  _QueryStateChanges._(QueryState<T> dataClass) {
    replace(dataClass);
  }

  void update(void Function(_QueryStateChanges<T> c) updates) => updates(this);

  void replace(covariant QueryState<T> dataClass) {
    isLoading = dataClass.isLoading;
    dataOrNull = dataClass.dataOrNull;
  }

  QueryState<T> build() => QueryState(
        isLoading: isLoading,
        dataOrNull: dataOrNull,
      );
}
