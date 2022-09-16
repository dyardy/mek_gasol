import 'dart:async';

import 'package:flutter/widgets.dart';

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
