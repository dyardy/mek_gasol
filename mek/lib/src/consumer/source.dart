import 'package:mek/src/consumer/_basic_source_subscription.dart';

typedef SourceListener<T> = void Function(T state);

typedef SourceCondition<T> = bool Function(T prev, T curr);

abstract class Source<T> {
  Source();

  SourceSubscription<T> listen();
}

abstract class SourceSubscription<T> {
  set listenWhen(SourceCondition<T>? condition);
  set listener(SourceListener<T> listener);

  SourceSubscription();

  factory SourceSubscription.from(T initialState, Subscriber<T> subscriber) =
      BasicSourceSubscription<T>;

  T read();

  void cancel();
}
