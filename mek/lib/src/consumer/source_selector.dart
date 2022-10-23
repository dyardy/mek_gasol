import 'package:mek/src/consumer/source.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'source_selector.g.dart';

typedef SourceSelector<T, R> = R Function(T state);

extension SelectSource<T> on Source<T> {
  Source<R> select<R>(SourceSelector<T, R> selector) => _SourceSelector(this, selector);
}

@DataClass()
class _SourceSelector<T, R> with _$_SourceSelector<T, R> implements Source<R> {
  final Source<T> source;
  final SourceSelector<T, R> selector;

  _SourceSelector(this.source, this.selector);

  @override
  SourceSubscription<R> listen() => _SelectorSourceSubscription(source.listen(), selector);
}

class _SelectorSourceSubscription<T, R> implements SourceSubscription<R> {
  final SourceSubscription<T> subscription;
  final SourceSelector<T, R> selector;

  _SelectorSourceSubscription(this.subscription, this.selector);

  @override
  set listenWhen(SourceCondition<R>? condition) {
    subscription.listenWhen =
        condition != null ? (prev, curr) => condition(selector(prev), selector(curr)) : null;
  }

  @override
  set listener(SourceListener<R> listener) {
    subscription.listener = (state) => listener(selector(state));
  }

  @override
  R read() => selector(subscription.read());

  @override
  void cancel() => subscription.cancel();
}
