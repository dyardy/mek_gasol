import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateNotifier;
import 'package:mek/src/consumer/_sources.dart';
import 'package:mek/src/consumer/source.dart';

extension SourceStream<T> on Stream<T> {
  Source<T> toSource(T initialValue) => StreamSource(this, initialValue);
}

extension SourceValueListenable<T> on ValueListenable<T> {
  Source<T> toSource() => ValueListenableSource(this);
}

// extension SourceListenable<T extends Listenable> on T {
//   Source<T> toSource() => ListenableSource(this);
// }

extension SourceStateStreamable<T> on StateStreamable<T> {
  Source<T> toSource() => StreamSource(stream, state);
}

extension SourceStateNotifier<T> on StateNotifier<T> {
  // ignore: invalid_use_of_protected_member
  Source<T> toSource() => StreamSource(stream, state);
}
