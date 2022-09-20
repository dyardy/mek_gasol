import 'dart:async';

import 'package:mek/src/form/blocs/field_bloc.dart';
import 'package:mek/src/shared/bloc_extensions.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:pure_extensions/pure_extensions.dart';
import 'package:rxdart/rxdart.dart';

part 'map_field_bloc.g.dart';

@DataClass(changeable: true)
class MapFieldBlocState<TKey, TValue> extends FieldBlocStateBase<Map<TKey, TValue>>
    with _$MapFieldBlocState<TKey, TValue> {
  final Map<TKey, FieldBlocRule<TValue>> fieldBlocs;
  final Map<TKey, FieldBlocStateBase<TValue>> fieldStates;

  MapFieldBlocState({
    required this.fieldBlocs,
    required this.fieldStates,
  });

  @override
  late final bool isEnabled = fieldStates.values.every((e) => e.isEnabled);

  @override
  late final bool isTouched = fieldStates.values.any((e) => e.isTouched);

  @override
  late final bool isInitial = fieldStates.values.every((e) => e.isInitial);

  @override
  late final Map<TKey, TValue> value = fieldStates.map((key, state) => MapEntry(key, state.value));

  @override
  late final List<Object> errors = fieldStates.values.expand((e) => e.errors).toList();
}

class MapFieldBloc<TKey, TValue>
    extends FieldBlocBase<MapFieldBlocState<TKey, TValue>, Map<TKey, TValue>> {
  StreamSubscription? _fieldBlocsSub;

  MapFieldBloc()
      : super(MapFieldBlocState(
          fieldBlocs: {},
          fieldStates: {},
        ));

  @override
  void changeValue(Map<TKey, TValue> value) {
    throw UnimplementedError();
  }

  @override
  void updateValue(Map<TKey, TValue> value) {
    throw UnimplementedError();
  }

  @override
  void updateInitialValue(Map<TKey, TValue> value) {
    throw UnimplementedError();
  }

  void addFieldBlocs(Map<TKey, FieldBlocRule<TValue>> fieldBlocs) {
    updateFieldBlocs({...state.fieldBlocs, ...fieldBlocs});
  }

  void updateFieldBlocs(Map<TKey, FieldBlocRule<TValue>> fieldBlocs) {
    _fieldBlocsSub?.cancel();

    emit(state.change((c) => c
      ..fieldBlocs = fieldBlocs
      ..fieldStates = fieldBlocs.map((key, fieldBloc) => MapEntry(key, fieldBloc.state))));

    _initListener();
  }

  @override
  void disable() {
    _fieldBlocsSub?.cancel();
    for (final field in state.fieldBlocs.values) {
      field.disable();
    }
    _restoreListener();
  }

  @override
  void enable() {
    _fieldBlocsSub?.cancel();
    for (final field in state.fieldBlocs.values) {
      field.enable();
    }
    _restoreListener();
  }

  @override
  void touch() {
    _fieldBlocsSub?.cancel();
    for (final field in state.fieldBlocs.values) {
      field.touch();
    }
    _restoreListener();
  }

  @override
  Future<void> close() async {
    await _fieldBlocsSub?.cancel();
    await Future.wait(state.fieldBlocs.generateIterable((key, value) => value.close()));
    return super.close();
  }

  void _restoreListener() {
    updateFieldBlocs(state.fieldBlocs);
  }

  void _initListener() {
    if (state.fieldBlocs.isEmpty) return;
    _fieldBlocsSub = hotStream
        .switchMap((state) {
          return Rx.combineLatest(state.fieldBlocs.generateIterable((key, fieldBloc) {
            return fieldBloc.hotStream.map((state) => MapEntry(key, state));
          }), (states) => Map.fromEntries(states)).skip(1);
        })
        .skip(1)
        .listen((states) {
          emit(state.change((c) => c..fieldStates = states));
        });
  }
}
