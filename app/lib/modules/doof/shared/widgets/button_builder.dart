import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// It does not return the [onPressed] callback in the [builder] when the user cannot interact
/// with the [mutationBloc] / [formControl]
class ButtonBuilder extends StatefulWidget {
  final VoidCallback? onPressed;

  final StateStreamableSource<MutationState>? mutationBloc;

  final AbstractControl? formControl;

  /// It allows you to submit the form even if it is not valid.
  ///
  /// Trigger the form validation and the form touch.
  final bool canSubmitInvalidForm;

  final Widget Function(BuildContext context, VoidCallback? onPressed) builder;

  const ButtonBuilder({
    Key? key,
    required this.onPressed,
    this.mutationBloc,
    this.formControl,
    this.canSubmitInvalidForm = false,
    required this.builder,
  })  : assert(formControl != null),
        super(key: key);

  @override
  State<ButtonBuilder> createState() => _ButtonBuilderState();
}

class _ButtonBuilderState extends State<ButtonBuilder> {
  StreamSubscription? _mutationBlocSub;
  StreamSubscription? _formControlSub;

  bool _canSubmitForm = false;
  bool _canMutate = false;

  bool get _canPress => _canSubmitForm && _canMutate;

  @override
  void initState() {
    super.initState();
    _listenMutationBloc();
    _initFormControl();
    _listenFormControl();
  }

  @override
  void didUpdateWidget(covariant ButtonBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mutationBloc != oldWidget.mutationBloc) {
      _mutationBlocSub?.cancel();
      _listenMutationBloc();
    }
    if (widget.canSubmitInvalidForm != oldWidget.canSubmitInvalidForm) {
      _initFormControl();
    }
    if (widget.formControl != oldWidget.formControl) {
      _formControlSub?.cancel();
      _listenFormControl();
    }
  }

  @override
  void dispose() {
    _mutationBlocSub?.cancel();
    _formControlSub?.cancel();
    super.dispose();
  }

  bool _checkFormStatus(ControlStatus status) {
    switch (status) {
      case ControlStatus.pending:
      case ControlStatus.disabled:
        return false;
      case ControlStatus.invalid:
        return widget.canSubmitInvalidForm;
      case ControlStatus.valid:
        return true;
    }
  }

  void _listenMutationBloc() {
    _canMutate = !(widget.mutationBloc?.state.isMutating ?? false);
    _mutationBlocSub = widget.mutationBloc?.stream.listen((state) {
      _updateState(canMutate: !state.isMutating);
    });
  }

  void _initFormControl() {
    _canSubmitForm = _checkFormStatus(widget.formControl?.status ?? ControlStatus.valid);
  }

  void _listenFormControl() {
    _formControlSub = widget.formControl?.statusChanged.listen((status) {
      _updateState(canSubmitForm: _checkFormStatus(status));
    });
  }

  void _updateState({bool? canMutate, bool? canSubmitForm}) {
    final wasCanPress = _canPress;

    _canMutate = canMutate ?? _canMutate;
    _canSubmitForm = canSubmitForm ?? _canSubmitForm;

    if (wasCanPress == _canPress) return;
    setState(() {});
  }

  void _onPressedSubmit() {
    if (!widget.formControl!.valid) {
      widget.formControl!.markAllAsTouched();
      return;
    }
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmitForm = widget.canSubmitInvalidForm && widget.formControl != null;

    final onPressed =
        widget.onPressed != null && canSubmitForm ? _onPressedSubmit : widget.onPressed;

    return widget.builder(context, _canPress ? onPressed : null);
  }
}
