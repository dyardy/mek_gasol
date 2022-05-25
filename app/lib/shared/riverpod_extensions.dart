import 'dart:async';

import 'package:riverpod/riverpod.dart';

extension RefExtensions on Ref {
  Future<void> maybeRefresh(ProviderBase<FutureOr<void>> provider) async {
    try {
      await refresh(provider);
    } catch (_) {}
  }

  ProviderSubscription<Future<T>> listenFuture<T>(
    AlwaysAliveProviderListenable<Future<T>> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) {
    return listen<Future<T>>(provider, (previous, next) async {
      listener(await previous, await next);
    }, onError: onError, fireImmediately: fireImmediately);
  }
}

extension LP<T> on Iterable<ProviderSubscription<T>> {
  void close() {
    for (final subscription in this) {
      subscription.close();
    }
  }
}
