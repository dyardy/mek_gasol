import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Observers {
  static const BlocObserver bloc = _BlocObserver();

  static const ProviderObserver provider = _ProviderObserver();
}

class _ProviderObserver extends ProviderObserver {
  const _ProviderObserver();

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);

    if (newValue is! AsyncError) return;
    FlutterError.dumpErrorToConsole(FlutterErrorDetails(
      library: 'riverpod',
      context: ErrorSummary('$provider'),
      exception: newValue.error,
      stack: newValue.stackTrace,
    ));
  }
}

class _BlocObserver with BlocObserver {
  const _BlocObserver();

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    FlutterError.dumpErrorToConsole(FlutterErrorDetails(
      library: 'bloc',
      context: ErrorSummary('${bloc.runtimeType}'),
      exception: error,
      stack: stackTrace,
    ));
  }
}
