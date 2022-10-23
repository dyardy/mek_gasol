// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:mek/src/stream/stream_consumer_base.dart';
//
// class BlocBuilder<TState> extends StreamConsumerBase<TState, TState> {
//   final StateStreamable<TState> bloc;
//   final bool Function(TState prev, TState curr)? buildWhen;
//   final Widget Function(BuildContext context, TState state) builder;
//
//   BlocBuilder({
//     Key? key,
//     required this.bloc,
//     this.buildWhen,
//     required this.builder,
//   }) : super(
//           key: key,
//           stream: bloc.stream,
//           initialValue: bloc.state,
//         );
//
//   @override
//   bool canBuild(BuildContext context, TState prev, TState curr) =>
//       buildWhen?.call(prev, curr) ?? true;
//
//   @override
//   Widget build(BuildContext context, TState value) => builder(context, value);
// }
//
// class BlocListener<TState> extends StreamConsumerBase<TState, TState> {
//   final bool Function(TState prev, TState curr)? listenWhen;
//   final void Function(BuildContext context, TState value) listener;
//   final Widget child;
//
//   BlocListener({
//     Key? key,
//     required StateStreamable<TState> bloc,
//     this.listenWhen,
//     required this.listener,
//     required this.child,
//   }) : super(
//           key: key,
//           stream: bloc.stream,
//           initialValue: bloc.state,
//         );
//
//   @override
//   bool canBuild(BuildContext context, TState prev, TState curr) {
//     if (listenWhen?.call(prev, curr) ?? true) listener(context, curr);
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context, TState value) => child;
// }
//
// class BlocConsumer<TState> extends StreamConsumerBase<TState, TState> {
//   final StateStreamable<TState> bloc;
//   final bool Function(TState prev, TState curr)? listenWhen;
//   final void Function(BuildContext context, TState value) listener;
//   final bool Function(TState prev, TState curr)? buildWhen;
//   final Widget Function(BuildContext context, TState state) builder;
//
//   BlocConsumer({
//     Key? key,
//     required this.bloc,
//     this.listenWhen,
//     required this.listener,
//     this.buildWhen,
//     required this.builder,
//   }) : super(
//           key: key,
//           stream: bloc.stream,
//           initialValue: bloc.state,
//         );
//
//   @override
//   bool canBuild(BuildContext context, TState prev, TState curr) {
//     if (listenWhen?.call(prev, curr) ?? true) listener(context, curr);
//     return buildWhen?.call(prev, curr) ?? true;
//   }
//
//   @override
//   Widget build(BuildContext context, TState value) => builder(context, value);
// }
