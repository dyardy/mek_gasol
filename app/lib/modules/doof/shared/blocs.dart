import 'dart:async';

import 'package:bloc/bloc.dart';

class MutationState {
  final bool isMutating;

  const MutationState({
    required this.isMutating,
  });

  MutationState copyWith({
    bool? isMutating,
  }) {
    return MutationState(
      isMutating: isMutating ?? this.isMutating,
    );
  }
}

class MutationBloc extends Cubit<MutationState> {
  MutationBloc() : super(const MutationState(isMutating: false));

  void handle<R>(
    FutureOr<R> Function() mutator, {
    void Function(Object error)? onFailed,
    void Function(R result)? onSuccess,
    void Function(Object? error, R? result)? onCompleted,
  }) async {
    emit(state.copyWith(isMutating: true));

    try {
      final result = await mutator();
      if (!isClosed) {
        onSuccess?.call(result);
        onCompleted?.call(null, result);
      }
    } catch (error) {
      if (!isClosed) {
        onFailed?.call(error);
        onCompleted?.call(error, null);
      }
      rethrow;
    } finally {
      emit(state.copyWith(isMutating: false));
    }
  }
}

class QueryState<T> {
  final bool isLoading;
  final T data;

  const QueryState({
    required this.isLoading,
    required this.data,
  });

  QueryState<T> copyWith({
    bool? isLoading,
    T? data,
  }) {
    return QueryState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}

class QueryBloc<T> extends Cubit<QueryState<T>> {
  late final StreamSubscription _sub;

  QueryBloc(Stream<T> Function() fetcher, {required T initialData})
      : super(QueryState(
          isLoading: true,
          data: initialData,
        )) {
    _init(fetcher);
  }

  void _init(Stream<T> Function() fetcher) async {
    _sub = fetcher().listen((data) {
      emit(state.copyWith(isLoading: false, data: data));
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
