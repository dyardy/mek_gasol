import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/src/riverpod/_provider_combiner.dart';

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
}
