import 'dart:async';

import 'package:riverpod/riverpod.dart';

extension RefExtensions on Ref {
  Future<void> maybeRefresh(ProviderBase<FutureOr<void>> provider) async {
    try {
      await refresh(provider);
    } catch (_) {}
  }
}
