import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

extension HotStreamBlocExtension<T> on StateStreamable<T> {
  Stream<T> get hotStream => Rx.merge([Stream.value(state), stream]);
}

extension SelectBlocExtension<State> on StateStreamable<State> {
  StateStreamable<R> select<R>(R Function(State state) selector) => _Selector(this, selector);
}

abstract class BlocUtils {
  static StateStreamable<R> combine<State, R>(
    List<StateStreamable<State>> blocs,
    R Function(List<State> states) combiner,
  ) {
    return _Combiner<State, R>(blocs, combiner);
  }

  static StateStreamable<R> combine2<State1, State2, R>(
    StateStreamable<State1> bloc1,
    StateStreamable<State2> bloc2,
    R Function(State1 state1, State2 state2) combiner,
  ) {
    return _Combiner([bloc1, bloc2], (states) {
      return combiner(states[0] as State1, states[1] as State2);
    });
  }

  static StateStreamable<R> combine3<State1, State2, State3, R>(
    StateStreamable<State1> bloc1,
    StateStreamable<State2> bloc2,
    StateStreamable<State3> bloc3,
    R Function(State1 state1, State2 state2, State3 state3) combiner,
  ) {
    return _Combiner([bloc1, bloc2], (states) {
      return combiner(states[0] as State1, states[1] as State2, states[2] as State3);
    });
  }
}

class _Selector<State, R> extends StateStreamable<R> {
  final StateStreamable<State> bloc;
  final R Function(State state) selector;

  _Selector(this.bloc, this.selector);

  @override
  R get state => selector(bloc.state);

  @override
  Stream<R> get stream => bloc.stream.map(selector);
}

class _Combiner<State, R> extends StateStreamable<R> {
  final List<StateStreamable<State>> blocs;
  final R Function(List<State> states) combiner;

  _Combiner(this.blocs, this.combiner);

  @override
  R get state => combiner(blocs.map((e) => e.state).toList());

  @override
  Stream<R> get stream => Rx.combineLatest(blocs.map((e) => e.hotStream), combiner).skip(1);
}
