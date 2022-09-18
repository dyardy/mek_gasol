import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'blocs.g.dart';

@DataClass()
abstract class MutationState<TData> with _$MutationState<TData> {
  const MutationState._();

  bool get isMutating;

  bool get isIdle => this is IdleMutation<TData>;
  bool get isLoading => this is LoadingMutation<TData>;
  bool get isFailed => this is FailedMutation<TData>;
  bool get isSuccess => this is SuccessMutation<TData>;

  MutationState<TData> toIdle() => IdleMutation();

  MutationState<TData> toLoading() => LoadingMutation();

  MutationState<TData> toFailed({
    bool isMutating = false,
    required Object error,
  }) {
    return FailedMutation(isMutating: isMutating, error: error);
  }

  MutationState<TData> toSuccess({
    bool isMutating = false,
    required TData data,
  }) {
    return SuccessMutation(isMutating: isMutating, data: data);
  }

  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  });

  R maybeMap<R>({
    R Function(IdleMutation<TData> state)? idle,
    R Function(LoadingMutation<TData> state)? loading,
    R Function(FailedMutation<TData> state)? failed,
    R Function(SuccessMutation<TData> state)? success,
    required R Function(MutationState<TData>) orElse,
  }) {
    return map(
      idle: idle ?? orElse,
      loading: loading ?? orElse,
      failed: failed ?? orElse,
      success: success ?? orElse,
    );
  }

  R? mapOrNull<R>({
    R Function(IdleMutation<TData> state)? idle,
    R Function(LoadingMutation<TData> state)? loading,
    R Function(FailedMutation<TData> state)? failed,
    R Function(SuccessMutation<TData> state)? success,
  }) {
    R? orNull(_) => null;
    return map(
      idle: idle ?? orNull,
      loading: loading ?? orNull,
      failed: failed ?? orNull,
      success: success ?? orNull,
    );
  }

  R when<R>({
    required R Function() idle,
    required R Function() loading,
    required R Function(Object error) failed,
    required R Function(TData data) success,
  }) {
    return map(
      idle: (state) => idle(),
      loading: (state) => loading(),
      failed: (state) => failed(state.error),
      success: (state) => success(state.data),
    );
  }

  R maybeWhen<R>({
    R Function()? idle,
    R Function()? loading,
    R Function(Object error)? failed,
    R Function(TData data)? success,
    required R Function() orElse,
  }) {
    return map(
      idle: (_) => idle == null ? orElse() : idle(),
      loading: (_) => loading == null ? orElse() : loading(),
      failed: (state) => failed == null ? orElse() : failed(state.error),
      success: (state) => success == null ? orElse() : success(state.data),
    );
  }

  R? whenOrNull<R>({
    R Function()? idle,
    R Function()? loading,
    R Function(Object error)? failed,
    R Function(TData data)? success,
  }) {
    return map(
      idle: (_) => idle?.call(),
      loading: (_) => loading?.call(),
      failed: (state) => failed?.call(state.error),
      success: (state) => success?.call(state.data),
    );
  }
}

@DataClass()
class IdleMutation<TData> extends MutationState<TData> with _$IdleMutation<TData> {
  IdleMutation() : super._();

  @override
  bool get isMutating => false;

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return idle(this);
  }
}

@DataClass()
class LoadingMutation<TData> extends MutationState<TData> with _$LoadingMutation<TData> {
  LoadingMutation() : super._();

  @override
  bool get isMutating => true;

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return loading(this);
  }
}

@DataClass()
class FailedMutation<TData> extends MutationState<TData> with _$FailedMutation<TData> {
  @override
  final bool isMutating;

  final Object error;

  FailedMutation({
    required this.isMutating,
    required this.error,
  }) : super._();

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return failed(this);
  }
}

@DataClass()
class SuccessMutation<TData> extends MutationState<TData> with _$SuccessMutation<TData> {
  @override
  final bool isMutating;

  final TData data;

  SuccessMutation({
    required this.isMutating,
    required this.data,
  }) : super._();

  @override
  R map<R>({
    required R Function(IdleMutation<TData> state) idle,
    required R Function(LoadingMutation<TData> state) loading,
    required R Function(FailedMutation<TData> state) failed,
    required R Function(SuccessMutation<TData> state) success,
  }) {
    return success(this);
  }
}

class MutationBloc<T> extends Cubit<MutationState<T>> {
  MutationBloc() : super(IdleMutation());

  void handle(
    FutureOr<T> Function() mutator, {
    void Function(Object error)? failed,
    void Function(T result)? success,
    void Function(Object? error, T? result)? completed,
  }) async {
    emit(state.toLoading());

    try {
      final result = await mutator();
      success?.call(result);
      completed?.call(null, result);
      emit(state.toSuccess(data: result));
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      failed?.call(error);
      completed?.call(error, null);
      emit(state.toFailed(error: error));
    }
  }
}

@DataClass(copyable: true)
class QueryState<T> with _$QueryState<T> {
  final bool isLoading;
  final T? dataOrNull;

  T get data => dataOrNull as T;

  QueryState({
    required this.isLoading,
    required this.dataOrNull,
  });
}

class QueryBloc<T> extends Cubit<QueryState<T>> {
  late final StreamSubscription _sub;

  QueryBloc(Stream<T> Function() fetcher)
      : super(QueryState<T>(
          isLoading: true,
          dataOrNull: null,
        )) {
    _init(fetcher);
  }

  void _init(Stream<T> Function() fetcher) async {
    _sub = fetcher().listen((data) {
      emit(state.copyWith(isLoading: false, dataOrNull: data));
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
