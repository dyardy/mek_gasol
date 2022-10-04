import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mek/mek.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:tuple/tuple.dart';

part 'query_bloc.g.dart';

abstract class QueryState<T> {
  T? get dataOrNull => null;
  T get data => dataOrNull as T;

  bool get hasData => dataOrNull != null;
  bool get isLoading => this is LoadingQuery<T>;

  R map<R>({
    required R Function(LoadingQuery<T> state) loading,
    required R Function(SuccessQuery<T> data) success,
  });

  QueryState<R> mapStateData<R>(QueryState<R> Function(T data) mapper) {
    return map(loading: (state) {
      return LoadingQuery();
    }, success: (state) {
      return mapper(state.data);
    });
  }
}

@DataClass()
class LoadingQuery<T> extends QueryState<T> with _$LoadingQuery<T> {
  @override
  R map<R>({
    required R Function(LoadingQuery<T> state) loading,
    required R Function(SuccessQuery<T> data) success,
  }) {
    return loading(this);
  }
}

@DataClass()
class SuccessQuery<T> extends QueryState<T> with _$SuccessQuery<T> {
  @override
  final T data;

  SuccessQuery({
    required this.data,
  });

  @override
  T? get dataOrNull => data;

  @override
  R map<R>({
    required R Function(LoadingQuery<T> state) loading,
    required R Function(SuccessQuery<T> data) success,
  }) {
    return success(this);
  }
}

class QueryBloc<T> extends Cubit<QueryState<T>> {
  late final StreamSubscription _sub;

  QueryBloc(Stream<T> Function() fetcher) : super(LoadingQuery()) {
    _init(fetcher);
  }

  static StateStreamable<QueryState<Tuple2<Data1, Data2>>> combine2<Data1, Data2, R>(
    StateStreamable<QueryState<Data1>> bloc1,
    StateStreamable<QueryState<Data2>> bloc2,
  ) {
    return BlocUtils.combine2(bloc1, bloc2, (state1, state2) {
      return state1.mapStateData((data1) {
        return state2.mapStateData((data2) {
          return SuccessQuery(data: Tuple2(data1, data2));
        });
      });
    });
  }

  static StateStreamable<QueryState<Tuple3<Data1, Data2, Data3>>> combine3<Data1, Data2, Data3, R>(
    StateStreamable<QueryState<Data1>> bloc1,
    StateStreamable<QueryState<Data2>> bloc2,
    StateStreamable<QueryState<Data3>> bloc3,
  ) {
    return BlocUtils.combine3(bloc1, bloc2, bloc3, (state1, state2, state3) {
      return state1.mapStateData((data1) {
        return state2.mapStateData((data2) {
          return state3.mapStateData((data3) {
            return SuccessQuery(data: Tuple3(data1, data2, data3));
          });
        });
      });
    });
  }

  void _init(Stream<T> Function() fetcher) async {
    _sub = fetcher().listen((data) {
      emit(SuccessQuery(data: data));
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
