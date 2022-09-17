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
  final T? dataOrNull;

  T get data => dataOrNull as T;

  QueryState({
    required this.isLoading,
    required this.dataOrNull,
  });

  QueryState<T> copyWith({
    bool? isLoading,
    T? dataOrNull,
  }) {
    return QueryState(
      isLoading: isLoading ?? this.isLoading,
      dataOrNull: dataOrNull ?? this.dataOrNull,
    );
  }
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
