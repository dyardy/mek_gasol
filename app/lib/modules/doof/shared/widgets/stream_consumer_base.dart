import 'dart:async';

import 'package:flutter/widgets.dart';

class ValueStreamListener<V> extends StreamConsumerBase<V, V?> {
  final bool Function(V? prev, V curr)? listenWhen;
  final void Function(BuildContext context, V value) listener;
  final Widget child;

  const ValueStreamListener({
    Key? key,
    required Stream<V> stream,
    this.listenWhen,
    required this.listener,
    required this.child,
  }) : super(
          key: key,
          stream: stream,
          initialValue: null,
        );

  @override
  bool canBuild(BuildContext context, V? prev, V curr) {
    if (listenWhen?.call(prev, curr) ?? true) listener(context, curr);
    return false;
  }

  @override
  Widget build(BuildContext context, V? value) => child;
}

class ValueStreamBuilder<V> extends StreamConsumerBase<V, V> {
  final bool Function(V? prev, V curr)? buildWhen;
  final Widget Function(BuildContext context, V value) builder;

  const ValueStreamBuilder({
    Key? key,
    required Stream<V> stream,
    required V initialValue,
    this.buildWhen,
    required this.builder,
  }) : super(
          key: key,
          stream: stream,
          initialValue: initialValue,
        );

  @override
  bool canBuild(BuildContext context, V? prev, V curr) {
    return buildWhen?.call(prev, curr) ?? true;
  }

  @override
  Widget build(BuildContext context, V value) => builder(context, value);
}

abstract class StreamConsumerBase<V extends PV, PV> extends StatefulWidget {
  final Stream<V> stream;
  final PV initialValue;

  const StreamConsumerBase({
    Key? key,
    required this.stream,
    required this.initialValue,
  }) : super(key: key);

  bool canBuild(BuildContext context, PV prev, V curr);

  Widget build(BuildContext context, PV value);

  @override
  State<StreamConsumerBase<V, PV>> createState() => _StreamConsumerBaseState();
}

class _StreamConsumerBaseState<V extends PV, PV> extends State<StreamConsumerBase<V, PV>> {
  late StreamSubscription _subscription;
  late PV _conditionValue;
  late PV _buildingValue;

  @override
  void initState() {
    super.initState();
    _conditionValue = widget.initialValue;
    _buildingValue = widget.initialValue;
    _subscription = widget.stream.listen(_listener);
  }

  @override
  void didUpdateWidget(covariant StreamConsumerBase<V, PV> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stream != oldWidget.stream) {
      _subscription.cancel();
      _subscription = widget.stream.listen(_listener);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _listener(V value) {
    if (widget.canBuild(context, _conditionValue, value)) {
      setState(() => _buildingValue = value);
    }
    _conditionValue = value;
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _buildingValue);
}
