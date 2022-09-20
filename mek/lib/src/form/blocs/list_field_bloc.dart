import 'dart:async';

import 'package:mek/src/form/blocs/field_bloc.dart';
import 'package:mek/src/shared/bloc_extensions.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:rxdart/rxdart.dart';

part 'list_field_bloc.g.dart';

@DataClass(changeable: true)
class ListFieldBlocState<TValue> extends FieldBlocStateBase<List<TValue>>
    with _$ListFieldBlocState<TValue> {
  final List<FieldBlocBase<FieldBlocStateBase<TValue>, TValue>> fieldBlocs;
  final List<FieldBlocStateBase<TValue>> fieldStates;

  ListFieldBlocState({
    required this.fieldBlocs,
    required this.fieldStates,
  });

  @override
  late final bool isEnabled = fieldStates.every((e) => e.isEnabled);

  @override
  late final bool isTouched = fieldStates.any((e) => e.isTouched);

  @override
  late final bool isInitial = fieldStates.every((e) => e.isInitial);

  @override
  late final List<TValue> value = fieldStates.map((e) => e.value).toList();

  @override
  late final List<Object> errors = fieldStates.expand((e) => e.errors).toList();
}

class ListFieldBloc<TValue> extends FieldBlocBase<ListFieldBlocState<TValue>, List<TValue>> {
  StreamSubscription? _fieldBlocsSub;

  ListFieldBloc({
    List<FieldBlocBase<FieldBlocStateBase<TValue>, TValue>> fieldBlocs = const [],
  }) : super(ListFieldBlocState(
          fieldBlocs: fieldBlocs,
          fieldStates: fieldBlocs.map((e) => e.state).toList(),
        )) {
    _initListener();
  }

  void addFieldBlocs(List<FieldBlocBase<FieldBlocStateBase<TValue>, TValue>> fieldBlocs) {
    _fieldBlocsSub?.cancel();

    emit(state.change((c) => c
      ..fieldBlocs = [...c.fieldBlocs, ...fieldBlocs]
      ..fieldStates = [...c.fieldBlocs.map((e) => e.state), ...fieldBlocs.map((e) => e.state)]));

    _initListener();
  }

  void updateFieldBlocs(List<FieldBlocBase<FieldBlocStateBase<TValue>, TValue>> fieldBlocs) {
    _fieldBlocsSub?.cancel();

    emit(state.change((c) => c
      ..fieldBlocs = fieldBlocs
      ..fieldStates = fieldBlocs.map((e) => e.state).toList()));

    _initListener();
  }

  @override
  void changeValue(List<TValue> value) {
    throw UnimplementedError();
  }

  @override
  void updateValue(List<TValue> value) {
    throw UnimplementedError();
  }

  @override
  void updateInitialValue(List<TValue> value) {
    throw UnimplementedError();
  }

  @override
  void disable() {
    _fieldBlocsSub?.cancel();
    for (final field in state.fieldBlocs) {
      field.disable();
    }
    _restoreListener();
  }

  @override
  void enable() {
    _fieldBlocsSub?.cancel();
    for (final field in state.fieldBlocs) {
      field.enable();
    }
    _restoreListener();
  }

  @override
  void touch() {
    _fieldBlocsSub?.cancel();
    for (final field in state.fieldBlocs) {
      field.touch();
    }
    _restoreListener();
  }

  void _initListener() {
    if (state.fieldBlocs.isEmpty) return;
    _fieldBlocsSub = hotStream
        .switchMap((state) => Rx.combineLatestList(state.fieldBlocs.map((e) => e.hotStream)))
        .skip(1)
        .listen((states) => emit(state.change((c) => c..fieldStates = states)));
  }

  void _restoreListener() {
    updateFieldBlocs(state.fieldBlocs);
  }

  @override
  Future<void> close() async {
    await Future.wait(state.fieldBlocs.map((e) => e.close()));
    await _fieldBlocsSub?.cancel();
    return super.close();
  }
}
