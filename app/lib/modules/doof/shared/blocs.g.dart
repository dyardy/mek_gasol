// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocs.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$MutationState<TData> {
  MutationState<TData> get _self => this as MutationState<TData>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$MutationState<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('MutationState', [TData])).toString();
}

mixin _$IdleMutation<TData> {
  IdleMutation<TData> get _self => this as IdleMutation<TData>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$IdleMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('IdleMutation', [TData])).toString();
}

mixin _$LoadingMutation<TData> {
  LoadingMutation<TData> get _self => this as LoadingMutation<TData>;

  Iterable<Object?> get _props sync* {}

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$LoadingMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('LoadingMutation', [TData])).toString();
}

mixin _$FailedMutation<TData> {
  FailedMutation<TData> get _self => this as FailedMutation<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.isMutating;
    yield _self.error;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$FailedMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('FailedMutation', [TData])
        ..add('isMutating', _self.isMutating)
        ..add('error', _self.error))
      .toString();
}

mixin _$SuccessMutation<TData> {
  SuccessMutation<TData> get _self => this as SuccessMutation<TData>;

  Iterable<Object?> get _props sync* {
    yield _self.isMutating;
    yield _self.data;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$SuccessMutation<TData> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('SuccessMutation', [TData])
        ..add('isMutating', _self.isMutating)
        ..add('data', _self.data))
      .toString();
}

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

  QueryState<T> copyWith({
    bool? isLoading,
    T? dataOrNull,
  }) {
    return QueryState(
      isLoading: isLoading ?? _self.isLoading,
      dataOrNull: dataOrNull ?? _self.dataOrNull,
    );
  }
}
