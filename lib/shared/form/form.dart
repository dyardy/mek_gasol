import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';

class TextFieldBuilder extends ConsumerStatefulWidget {
  final FieldBloc<String> fieldBloc;

  const TextFieldBuilder({
    Key? key,
    required this.fieldBloc,
  }) : super(key: key);

  @override
  _TextFieldBuilderState createState() => _TextFieldBuilderState();
}

class _TextFieldBuilderState extends ConsumerState<TextFieldBuilder> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.fieldBloc.state.value);
  }

  @override
  void didUpdateWidget(covariant TextFieldBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fieldBloc != oldWidget.fieldBloc) {
      _controller.dispose();
      _controller = TextEditingController(text: widget.fieldBloc.state.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CubitConsumer<FieldBlocState<String>>(
      bloc: widget.fieldBloc,
      listener: (context, state) {
        _controller.text = state.value;
      },
      builder: (context, state, _) {
        final field = CupertinoTextField(
          controller: _controller,
          onChanged: widget.fieldBloc.updateValue,
        );

        final error = state.error;

        return CupertinoFormRow(
          error: error != null ? Text('$error') : null,
          child: field,
        );
      },
    );
  }
}

class CubitConsumer<TState> extends StatefulWidget {
  final Cubit<TState> bloc;
  final bool fireImmediately;
  final void Function(BuildContext context, TState state)? listener;
  final Widget child;
  final Widget Function(BuildContext context, TState state, Widget child)? builder;

  const CubitConsumer({
    Key? key,
    required this.bloc,
    this.fireImmediately = false,
    this.listener,
    this.child = const SizedBox.shrink(),
    this.builder,
  }) : super(key: key);

  @override
  _CubitConsumerState<TState> createState() => _CubitConsumerState();
}

class _CubitConsumerState<TState> extends State<CubitConsumer<TState>> {
  late StreamSubscription _sub;
  late TState _state;

  @override
  void initState() {
    super.initState();
    _initListener();
  }

  @override
  void didUpdateWidget(covariant CubitConsumer<TState> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bloc != oldWidget.bloc) {
      _sub.cancel();
      _initListener();
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _initListener() {
    _state = widget.bloc.state;
    _sub = widget.bloc.stream.listen((state) {
      widget.listener?.call(context, state);
      if (widget.builder != null) {
        setState(() {
          _state = state;
        });
      } else {
        _state = state;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder?.call(context, _state, widget.child) ?? widget.child;
  }
}
