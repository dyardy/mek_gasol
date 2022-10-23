import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mek/src/consumer/source.dart';
import 'package:mek_data_class/mek_data_class.dart';

part '_sources.g.dart';

@DataClass()
class StreamSource<T> with _$StreamSource<T> implements Source<T> {
  final Stream<T> stream;
  @DataField(comparable: false)
  final T initialValue;

  StreamSource(this.stream, this.initialValue);

  @override
  SourceSubscription<T> listen() {
    return SourceSubscription.from(initialValue, (emit) => stream.listen(emit).cancel);
  }
}

@DataClass()
class ListenableSource<T extends Listenable> with _$ListenableSource<T> implements Source<T> {
  final T listenable;

  ListenableSource(this.listenable);

  @override
  SourceSubscription<T> listen() {
    return SourceSubscription.from(listenable, (emit) {
      void listener() => emit(listenable);
      listenable.addListener(listener);
      return () => listenable.removeListener(listener);
    });
  }
}

@DataClass()
class ValueListenableSource<T> with _$ValueListenableSource<T> implements Source<T> {
  final ValueListenable<T> valueListenable;

  ValueListenableSource(this.valueListenable);

  @override
  SourceSubscription<T> listen() {
    return SourceSubscription.from(valueListenable.value, (emit) {
      void listener() => emit(valueListenable.value);
      valueListenable.addListener(listener);
      return () => valueListenable.removeListener(listener);
    });
  }
}
