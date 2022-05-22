import 'dart:async';

import 'package:riverpod/riverpod.dart';

extension RefExtensions on Ref {
  Future<void> maybeRefresh(ProviderBase<FutureOr<void>> provider) async {
    try {
      await refresh(provider);
    } catch (_) {}
  }

  void listenFuture<T>(
    AlwaysAliveProviderListenable<Future<T>> provider,
    void Function(T? previous, T next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) {
    listen<Future<T>>(provider, (previous, next) async {
      listener(await previous, await next);
    }, onError: onError, fireImmediately: fireImmediately);
  }
}
