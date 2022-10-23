import 'package:flutter/foundation.dart';
import 'package:mek/src/consumer/source.dart';

typedef Subscriber<T> = VoidCallback Function(void Function(T state) emit);

class BasicSourceSubscription<T> extends SourceSubscription<T> {
  final Subscriber<T> _subscriber;
  T _currentState;
  T _effectiveState;

  SourceCondition<T>? _listenWhen;
  SourceListener<T>? _listener;
  VoidCallback? _canceler;

  BasicSourceSubscription(T initialState, this._subscriber)
      : _currentState = initialState,
        _effectiveState = initialState;

  @override
  set listenWhen(SourceCondition<T>? condition) {
    _listenWhen = condition;
  }

  @override
  set listener(SourceListener<T> listener) {
    _listener = listener;
    _canceler ??= _subscriber(_emit);
  }

  @override
  T read() => _currentState;

  @override
  void cancel() {
    _listener = null;
    _canceler?.call();
    _canceler = null;
  }

  void _emit(T state) {
    try {
      if (!(_listenWhen?.call(_effectiveState, state) ?? true)) return;
    } finally {
      _currentState = state;
    }

    _effectiveState = state;
    _listener!(state);
  }
}
