import 'package:flutter/widgets.dart';

class DefaultPrimaryScrollController extends StatefulWidget {
  final Widget child;

  const DefaultPrimaryScrollController({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<DefaultPrimaryScrollController> createState() => _DefaultPrimaryScrollControllerState();
}

class _DefaultPrimaryScrollControllerState extends State<DefaultPrimaryScrollController> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _controller,
      child: widget.child,
    );
  }
}
