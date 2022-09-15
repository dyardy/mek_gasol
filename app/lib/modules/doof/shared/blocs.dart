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
