import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';

class TextFieldBuilder extends ConsumerStatefulWidget {
  final FieldBloc<String> fieldBloc;
  final TextFieldType type;
  final String? placeholderText;
  final Widget? helper;

  const TextFieldBuilder({
    Key? key,
    required this.fieldBloc,
    this.type = const TextFieldType(),
    this.placeholderText,
    this.helper,
  }) : super(key: key);

  @override
  ConsumerState<TextFieldBuilder> createState() => _TextFieldBuilderState();
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
        if (_controller.text == state.value) return;
        _controller.text = state.value;
      },
      builder: (context, state, _) {
        final field = CupertinoTextField(
          controller: _controller,
          placeholder: widget.placeholderText,
          onChanged: widget.fieldBloc.changeValue,
          keyboardType: widget.type.getKeyboardType(),
          inputFormatters: widget.type.getInputFormatters(),
        );

        final error = state.error;

        return CupertinoFormRow(
          helper: widget.helper,
          error: error != null ? Text('$error') : null,
          child: field,
        );
      },
    );
  }
}

class TextFieldType {
  const TextFieldType();

  const factory TextFieldType.numeric({bool signed, bool decimal}) = _NumericTextFieldType;

  TextInputType? getKeyboardType() => null;

  List<TextInputFormatter> getInputFormatters() => const [];
}

class _NumericTextFieldType extends TextFieldType {
  final bool signed;
  final bool decimal;

  const _NumericTextFieldType({
    this.signed = false,
    this.decimal = false,
  });

  @override
  TextInputType? getKeyboardType() {
    return TextInputType.numberWithOptions(signed: signed, decimal: decimal);
  }

  @override
  List<TextInputFormatter> getInputFormatters() {
    final b = StringBuffer('[');
    b.write('0-9');
    if (signed) b.write('-');
    if (decimal) b.write('.,');
    b.write(']');

    return [FilteringTextInputFormatter.allow(RegExp(b.toString()))];
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
  State<CubitConsumer<TState>> createState() => _CubitConsumerState();
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
