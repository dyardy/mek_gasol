import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/stream_consumer_base.dart';

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
          return const Center(child: CircularProgressIndicator());
        }
        return builder(context, state.data);
      },
    );
  }
}

class BlocBuilder<TState> extends StreamConsumerBase<TState, TState> {
  final StateStreamable<TState> bloc;
  final bool Function(TState prev, TState curr)? buildWhen;
  final Widget Function(BuildContext context, TState state) builder;

  BlocBuilder({
    Key? key,
    required this.bloc,
    this.buildWhen,
    required this.builder,
  }) : super(
          key: key,
          stream: bloc.stream,
          initialValue: bloc.state,
        );

  @override
  bool canBuild(BuildContext context, TState prev, TState curr) =>
      buildWhen?.call(prev, curr) ?? true;

  @override
  Widget build(BuildContext context, TState value) => builder(context, value);
}

class BlocListener<TState> extends StreamConsumerBase<TState, TState> {
  final bool Function(TState prev, TState curr)? listenWhen;
  final void Function(BuildContext context, TState value) listener;
  final Widget child;

  BlocListener({
    Key? key,
    required StateStreamable<TState> bloc,
    this.listenWhen,
    required this.listener,
    required this.child,
  }) : super(
          key: key,
          stream: bloc.stream,
          initialValue: bloc.state,
        );

  @override
  bool canBuild(BuildContext context, TState prev, TState curr) {
    if (listenWhen?.call(prev, curr) ?? true) listener(context, curr);
    return false;
  }

  @override
  Widget build(BuildContext context, TState value) => child;
}
