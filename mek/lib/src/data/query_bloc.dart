import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'query_bloc.g.dart';

@DataClass(changeable: true)
class QueryState<T> with _$QueryState<T> {
  final bool isLoading;
  final T? dataOrNull;

  T get data => dataOrNull as T;

  QueryState({
    required this.isLoading,
    required this.dataOrNull,
  });
}

class QueryBloc<T> extends Cubit<QueryState<T>> {
  late final StreamSubscription _sub;

  QueryBloc(Stream<T> Function() fetcher)
      : super(QueryState<T>(
          isLoading: true,
          dataOrNull: null,
        )) {
    _init(fetcher);
  }

  void _init(Stream<T> Function() fetcher) async {
    _sub = fetcher().listen((data) {
      emit(state.change((c) => c
        ..isLoading = false
        ..dataOrNull = data));
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
