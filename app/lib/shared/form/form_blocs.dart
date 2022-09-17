import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/shared/form/form_validators.dart';
import 'package:pure_extensions/pure_extensions.dart';
import 'package:rxdart/rxdart.dart';

part 'form_blocs.g.dart';

extension<T> on StateStreamableSource<T> {
  Stream<T> get hotStream => Rx.merge([Stream.value(state), stream]);
}

@DataClass(changeable: true)
abstract class FieldBlocStateBase<TValue> with _$FieldBlocStateBase<TValue> {
  bool get isEnabled;
  TValue get value;
  bool get isValid;
  bool get isInitial;
  bool get isChanged;
  List<Object> get errors;

  const FieldBlocStateBase();

  bool get isInvalid => !isValid;
}

abstract class FieldBlocBase<TState extends FieldBlocStateBase<TValue>, TValue>
    extends Cubit<TState> {
  FieldBlocBase(TState initialState) : super(initialState);

  void changeValue(TValue value);

  void updateValue(TValue value);

  void updateInitialValue(TValue value);

  void enable();

  void disable();
}

typedef FieldBlocRule<TValue> = FieldBlocBase<FieldBlocStateBase<TValue>, TValue>;

@DataClass(changeable: true)
class FieldBlocState<TValue> extends FieldBlocStateBase<TValue> with _$FieldBlocState<TValue> {
  @override
  final bool isEnabled;
  final TValue initialValue;
  @override
  final TValue value;
  @override
  final bool isChanged;
  @override
  final List<Object> errors;

  const FieldBlocState({
    required this.isEnabled,
    required this.initialValue,
    required this.value,
    required this.isChanged,
    required this.errors,
  });

  @override
  bool get isValid => errors.isEmpty;

  @override
  bool get isInitial => initialValue == value;
}

class FieldBloc<TValue> extends FieldBlocBase<FieldBlocState<TValue>, TValue> {
  final List<Validator<TValue>> _validators;

  FieldBloc({
    required TValue initialValue,
    List<Validator<TValue>> validators = const [],
  })  : _validators = validators,
        super(FieldBlocState(
          isEnabled: true,
          initialValue: initialValue,
          value: initialValue,
          isChanged: false,
          errors: _validate(validators, initialValue),
        ));

  @override
  void changeValue(TValue value) {
    emit(state.change((c) => c
      ..value = value
      ..isChanged = true
      ..errors = _validate(_validators, value)));
  }

  @override
  void updateValue(TValue? value) {
    final effectiveValue = value is! TValue ? state.initialValue : value;
    emit(state.change((c) => c
      ..value = effectiveValue
      ..isChanged = false
      ..errors = _validate(_validators, effectiveValue)));
  }

  @override
  void updateInitialValue(TValue value) {
    emit(state.change((c) => c
      ..initialValue = value
      ..value = value
      ..isChanged = false
      ..errors = _validate(_validators, value)));
  }

  void addValidators(List<Validator<TValue>> validators) {
    _validators.addAll(validators);
    emit(state.change((c) => c..errors = _validate(_validators, state.value)));
  }

  static List<Object> _validate<T>(List<Validator<T>> validators, T value) {
    for (final validator in validators) {
      final errors = validator(value);
      if (errors.isNotEmpty) return errors;
    }
    return [];
  }

  @override
  void disable() => emit(state.change((c) => c..isEnabled = false));

  @override
  void enable() => emit(state.change((c) => c..isEnabled = true));
}

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
  late final bool isInitial = fieldStates.every((e) => e.isInitial);

  @override
  late final bool isValid = fieldStates.every((e) => e.isValid);

  @override
  late final List<TValue> value = fieldStates.map((e) => e.value).toList();

  @override
  late final bool isChanged = fieldStates.any((e) => e.isChanged);

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
  late final bool isInitial = fieldStates.values.every((e) => e.isInitial);

  @override
  late final bool isValid = fieldStates.values.every((e) => e.isValid);

  @override
  late final Map<TKey, TValue> value = fieldStates.map((key, state) => MapEntry(key, state.value));

  @override
  late final bool isChanged = fieldStates.values.every((e) => !e.isChanged);

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

  void _restoreListener() {
    updateFieldBlocs(state.fieldBlocs);
  }

  @override
  Future<void> close() async {
    await _fieldBlocsSub?.cancel();
    await Future.wait(state.fieldBlocs.generateIterable((key, value) => value.close()));
    return super.close();
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

extension EqualsMap<K, V> on Map<K, V> {
  bool equals(Map<K, V> other) => const MapEquality().equals(this, other);
}
