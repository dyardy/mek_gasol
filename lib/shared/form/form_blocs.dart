import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/shared/form/form_validators.dart';
import 'package:rxdart/rxdart.dart';

part 'form_blocs.g.dart';

extension<T> on BlocBase<T> {
  Stream<T> get hotStream => Rx.merge([Stream.value(state), stream]);
}

@DataClass(changeable: true)
abstract class FieldBlocStateBase<TValue> with _$FieldBlocStateBase<TValue> {
  TValue get value;
  bool get isValid;
  bool get isInitial;
  bool get isChanged;

  const FieldBlocStateBase();
}

abstract class FieldBlocBase<TState extends FieldBlocStateBase<TValue>, TValue>
    extends Cubit<TState> {
  FieldBlocBase(TState initialState) : super(initialState);

  void changeValue(TValue value);

  void updateValue(TValue value);

  void updateInitialValue(TValue value);
}

@DataClass(changeable: true)
class FieldBlocState<TValue> extends FieldBlocStateBase<TValue> with _$FieldBlocState<TValue> {
  final TValue initialValue;
  @override
  final TValue value;
  final bool isChanged;
  final Object? error;

  const FieldBlocState({
    required this.initialValue,
    required this.value,
    required this.isChanged,
    required this.error,
  });

  @override
  bool get isValid => error == null;

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
          initialValue: initialValue,
          value: initialValue,
          isChanged: false,
          error: _validate(validators, initialValue),
        ));

  @override
  void changeValue(TValue value) {
    emit(state.change((c) => c
      ..value = value
      ..isChanged = true
      ..error = _validate(_validators, value)));
  }

  @override
  void updateValue(TValue value) {
    emit(state.change((c) => c
      ..value = value
      ..isChanged = false
      ..error = _validate(_validators, value)));
  }

  @override
  void updateInitialValue(TValue value) {
    emit(state.change((c) => c
      ..initialValue = value
      ..value = value
      ..isChanged = false
      ..error = _validate(_validators, value)));
  }

  void addValidators(List<Validator<TValue>> validators) {
    _validators.addAll(validators);
    emit(state.change((c) => c..error = _validate(_validators, state.value)));
  }

  static Object? _validate<T>(List<Validator<T>> validators, T value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}

abstract class Adapter<TFine, TRaw> {
  TFine from(TRaw value);

  TRaw to(TFine value);
}

class IntegerAdapter extends Adapter<int, String> {
  @override
  int from(String value) => int.tryParse(value) ?? 0;

  @override
  String to(int value) => '$value';
}

class AdaptiveFieldBloc<TFine, TRaw> extends FieldBlocBase<FieldBlocState<TFine>, TFine> {
  final Adapter<TFine, TRaw> _adapter;
  final FieldBloc<TRaw> fieldBloc;
  final List<Validator<TFine>> _validators;

  late StreamSubscription _sub;

  AdaptiveFieldBloc({
    required Adapter<TFine, TRaw> adapter,
    required this.fieldBloc,
    List<Validator<TFine>> validators = const [],
  })  : _adapter = adapter,
        _validators = validators,
        super(FieldBlocState(
          initialValue: adapter.from(fieldBloc.state.value),
          value: adapter.from(fieldBloc.state.value),
          isChanged: fieldBloc.state.isChanged,
          error: null,
        )) {
    _sub = fieldBloc.stream.listen((state) {
      final value = adapter.from(state.value);
      emit(FieldBlocState(
        initialValue: adapter.from(state.initialValue),
        value: value,
        isChanged: state.isChanged,
        error: state.error ?? _validate(value),
      ));
    });
  }

  @override
  void changeValue(TFine value) {
    fieldBloc.changeValue(_adapter.to(value));
  }

  @override
  void updateValue(TFine value) {
    fieldBloc.updateValue(_adapter.to(value));
  }

  @override
  void updateInitialValue(TFine value) {
    fieldBloc.updateInitialValue(_adapter.to(value));
  }

  void addValidators(List<Validator<TFine>> validators) {
    _validators.addAll(validators);
    emit(state.change((c) => c..error = fieldBloc.state.error ?? _validate(state.value)));
  }

  Object? _validate(TFine value) {
    for (final validator in _validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
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
  late final bool isInitial = fieldStates.every((e) => e.isInitial);

  @override
  late final bool isValid = fieldStates.every((e) => e.isValid);

  @override
  late final List<TValue> value = fieldStates.map((e) => e.value).toList();

  @override
  late final bool isChanged = fieldStates.any((e) => e.isChanged);
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

  void _initListener() {
    if (state.fieldBlocs.isEmpty) return;
    _fieldBlocsSub = hotStream
        .switchMap((state) => Rx.combineLatestList(state.fieldBlocs.map((e) => e.hotStream)))
        .skip(1)
        .listen((states) => emit(state.change((c) => c..fieldStates = states)));
  }

  @override
  Future<void> close() async {
    await Future.wait(state.fieldBlocs.map((e) => e.close()));
    await _fieldBlocsSub?.cancel();
    return super.close();
  }

  @override
  void changeValue(List<TValue> value) {
    // TODO: implement changeValue
  }

  @override
  void updateValue(List<TValue> value, [bool isInitial = false]) {
    // TODO: implement updateValue
  }

  @override
  void updateInitialValue(List<TValue> value) {
    // TODO: implement updateInitialValue
  }
}

// @DataClass(changeable: true)
// class MapFieldBlocState<TKey, TValue> extends FieldBlocState<Map<TKey, TValue>>
//     with _$ListFieldBlocState<Map<TKey, TValue>> {
//   final Map<TKey, FieldBloc<FieldBlocState<TValue>, TValue>> fieldBlocs;
//
//   final Map<TKey, TValue> value;
//   @override
//   final bool isValid;
//
//   const MapFieldBlocState({
//     required this.fieldBlocs,
//     required this.value,
//     required this.isValid,
//   });
// }
//
// class MapFieldBloc<TKey, TValue> extends FieldBloc<MapFieldBlocState<TKey, TValue>, Map<TKey, TValue>> {
//   late final StreamSubscription _fieldBlocsSub;
//
//   MapFieldBloc()
//       : super(MapFieldBlocState(
//     fieldBlocs: [],
//     value: [],
//     isValid: false,
//   )) {
//     _fieldBlocsSub = stream.startWith(state).switchMap((state) {
//       return Rx.combineLatestList(state.fieldBlocs.map((e) => e.stream.startWith(e.state)));
//     }).listen((states) {
//       emit(state.change((c) => c
//         ..value = states.map((e) => e.value).toList()
//         ..isValid = states.every((e) => e.isValid)));
//     });
//   }
//
//   void addFieldBlocs(List<FieldBloc<FieldBlocState<TValue>, TValue>> fieldBlocs) {
//     emit(state.change((c) => [...c.fieldBlocs, ...fieldBlocs]));
//   }
//
//   @override
//   Future<void> close() async {
//     await _fieldBlocsSub.cancel();
//     return super.close();
//   }
//
//   @override
//   void updateValue(List<TValue> value) {
//     // TODO: implement updateValue
//   }
// }
