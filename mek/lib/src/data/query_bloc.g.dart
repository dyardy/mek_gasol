// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_bloc.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$LoadingQuery<T> {
  LoadingQuery<T> get _self => this as LoadingQuery<T>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$LoadingQuery<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('LoadingQuery', [T])).toString();
}

mixin _$SuccessQuery<T> {
  SuccessQuery<T> get _self => this as SuccessQuery<T>;

  Iterable<Object?> get _props sync* {
    yield _self.data;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$SuccessQuery<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('SuccessQuery', [T])..add('data', _self.data)).toString();
}
