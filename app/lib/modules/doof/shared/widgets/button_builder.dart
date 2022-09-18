import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';
import 'package:rxdart/rxdart.dart';

/// It does not return the [onPressed] callback in the [builder] when the user cannot interact
/// with the [mutationBloc] / [formControl]
class ButtonBuilder extends StatefulWidget {
  final VoidCallback? onPressed;

  final Set<StateStreamableSource<QueryState>> queryBlocs;

  final Set<StateStreamableSource<MutationState>> mutationBlocs;

  final FieldBlocRule<dynamic>? formBloc;

  /// It allows you to submit the form even if it is not valid.
  ///
  /// Trigger the form validation and the form touch.
  final bool canSubmitInvalidForm;

  final Widget Function(BuildContext context, VoidCallback? onPressed) builder;

  ButtonBuilder({
    Key? key,
    required this.onPressed,
    this.queryBlocs = const {},
    this.mutationBlocs = const {},
    this.formBloc,
    this.canSubmitInvalidForm = true,
    required this.builder,
  })  : assert(queryBlocs.isNotEmpty || mutationBlocs.isNotEmpty || formBloc != null),
        super(key: key);

  @override
  State<ButtonBuilder> createState() => _ButtonBuilderState();
}

class _ButtonBuilderState extends State<ButtonBuilder> {
  StreamSubscription? _queryBlocSub;
  StreamSubscription? _mutationBlocSub;
  StreamSubscription? _formBlocSub;

  bool _canQuery = false;
  bool _canMutate = false;
  bool _canSubmitForm = false;

  bool get _canPress => _canQuery && _canMutate && _canSubmitForm;

  @override
  void initState() {
    super.initState();
    _listenQueryBloc();
    _listenMutationBloc();
    _listenFormBloc();
  }

  @override
  void didUpdateWidget(covariant ButtonBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.queryBlocs.equals(oldWidget.queryBlocs)) {
      _queryBlocSub?.cancel();
      _listenQueryBloc();
    }
    if (!widget.mutationBlocs.equals(oldWidget.mutationBlocs)) {
      _mutationBlocSub?.cancel();
      _listenMutationBloc();
    }
    if (widget.formBloc != oldWidget.formBloc) {
      _formBlocSub?.cancel();
      _listenFormBloc();
    }
  }

  @override
  void dispose() {
    _queryBlocSub?.cancel();
    _mutationBlocSub?.cancel();
    _formBlocSub?.cancel();
    super.dispose();
  }

  bool _checkFormBlocStatus(FieldBlocStateBase<dynamic>? state) {
    if (state == null) return true;
    if (!state.isEnabled) return false;
    if (state.isInvalid) return widget.canSubmitInvalidForm;
    return true;
  }

  void _listenQueryBloc() {
    _canQuery = widget.queryBlocs.every((e) => !e.state.isLoading);
    _mutationBlocSub = Rx.combineLatestList(widget.queryBlocs.map((e) {
      return e.hotStream;
    })).skip(1).listen((states) {
      _updateState(canQuery: states.every((e) => !e.isLoading));
    });
  }

  void _listenMutationBloc() {
    _canMutate = widget.mutationBlocs.every((e) => !e.state.isMutating);
    _mutationBlocSub = Rx.combineLatestList(widget.mutationBlocs.map((e) {
      return e.hotStream;
    })).skip(1).listen((states) {
      _updateState(canMutate: states.every((e) => !e.isMutating));
    });
  }

  void _listenFormBloc() {
    _canSubmitForm = _checkFormBlocStatus(widget.formBloc?.state);
    _formBlocSub = widget.formBloc?.stream.listen((state) {
      _updateState(canSubmitForm: _checkFormBlocStatus(state));
    });
  }

  void _updateState({bool? canQuery, bool? canMutate, bool? canSubmitForm}) {
    final wasCanPress = _canPress;

    _canQuery = canQuery ?? _canQuery;
    _canMutate = canMutate ?? _canMutate;
    _canSubmitForm = canSubmitForm ?? _canSubmitForm;
    if (wasCanPress == _canPress) return;
    setState(() {});
  }

  void _onPressedSubmit() {
    if (widget.formBloc!.state.isInvalid) {
      widget.formBloc!.touch();
      return;
    }
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    // print('_canQuery:$_canQuery _canMutate:$_canMutate _canSubmitForm:$_canSubmitForm');
    final canSubmitForm = widget.canSubmitInvalidForm && widget.formBloc != null;

    final onPressed =
        widget.onPressed != null && canSubmitForm ? _onPressedSubmit : widget.onPressed;

    return widget.builder(context, _canPress ? onPressed : null);
  }
}

extension EqualsSet<T> on Set<T> {
  bool equals(Set<T> other) => const SetEquality().equals(this, other);
}
