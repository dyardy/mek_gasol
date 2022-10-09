import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/src/riverpod/_provider_combiner.dart';
import 'package:tuple/tuple.dart';

extension AsyncValueExtensions<T> on AsyncValue<T> {
  T get requiredValue => value as T;
}

abstract class Provide {
  static ProviderListenable<R> combineList<T, R>(
    Iterable<ProviderListenable<T>> providers,
    R Function(List<T> states) combiner,
  ) {
    return ProviderCombiner(providers: providers, combiner: combiner);
  }

  static ProviderListenable<AsyncValue<R>> combineAsyncList<T, R>(
    Iterable<ProviderListenable<AsyncValue<T>>> providers,
    R Function(List<T> values) combiner,
  ) {
    return ProviderCombiner(
      providers: providers,
      combiner: (states) {
        AsyncValue<R>? current;

        if (states.any((element) => element.isLoading)) {
          current = AsyncValue<R>.loading();
        }

        final error = states.firstType<AsyncError>();
        if (error != null) {
          final next = AsyncValue<R>.error(error.error, error.stackTrace);
          current = current?.copyWithPrevious(next) ?? next;
        }

        if (states.every((state) => state.hasValue)) {
          final next = AsyncValue<R>.data(combiner(states.map((e) => e.requiredValue).toList()));
          current = current?.copyWithPrevious(next) ?? next;
        }

        return current ?? AsyncLoading<R>();
      },
    );
  }

  static ProviderListenable<AsyncValue<Tuple2<T1, T2>>> combineAsync2<T1, T2, R>(
    ProviderListenable<AsyncValue<T1>> provider1,
    ProviderListenable<AsyncValue<T2>> provider2,
  ) {
    return combineAsyncList([provider1, provider2], Tuple2.fromList);
  }

  static ProviderListenable<AsyncValue<Tuple3<T1, T2, T3>>> combineAsync3<T1, T2, T3>(
    ProviderListenable<AsyncValue<T1>> provider1,
    ProviderListenable<AsyncValue<T2>> provider2,
    ProviderListenable<AsyncValue<T3>> provider3,
  ) {
    return combineAsyncList([provider1, provider2, provider3], Tuple3.fromList);
  }
}

extension IterableExtension<T> on Iterable<T> {
  R? firstType<R extends Object>() {
    for (final element in this) {
      if (element is R) return element;
    }
    return null;
  }
}

// abstract class Async {
//   static AsyncValue<T> combine<T, R>(List<AsyncValue<T>> values, R Function(T values) combiner) {
//     final errors = values.whereType<AsyncError<T>>();
//     if (errors.isNotEmpty) return AsyncError(errors.first.error, errors.first.stackTrace);
//     final data = values.whereType<AsyncData<T>>();
//     if (data.)
//   }
// }
