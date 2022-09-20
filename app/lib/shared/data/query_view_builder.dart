import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';

class QueryViewBuilder<T> extends StatelessWidget {
  final StateStreamable<QueryState<T>> bloc;
  final bool Function(QueryState<T> prev, QueryState<T> curr)? buildWhen;
  final Widget Function(BuildContext context, T data) builder;

  const QueryViewBuilder({
    super.key,
    required this.bloc,
    this.buildWhen,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const LoadingView();
        }
        return builder(context, state.data);
      },
    );
  }
}
