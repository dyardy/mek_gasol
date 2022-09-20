import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

extension HotStreamBlocExtension<T> on StateStreamableSource<T> {
  Stream<T> get hotStream => Rx.merge([Stream.value(state), stream]);
}
