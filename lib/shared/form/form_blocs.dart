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
abstract class FieldBlocStateBase<TValue> with _$FieldBlocState<TValue> {
  TValue get value;
  bool get isValid;

  const FieldBlocStateBase();
}

abstract class FieldBlocBase<TState extends FieldBlocStateBase<TValue>, TValue>
    extends Cubit<TState> {
  FieldBlocBase(TState initialState) : super(initialState);

  void updateValue(TValue value);
}

@DataClass(changeable: true)
class FieldBlocState<TValue> extends FieldBlocStateBase<TValue>
    with _$SingleFieldBlocState<TValue> {
  @override
  final TValue value;
  final Object? error;

  const FieldBlocState({
    required this.value,
    required this.error,
  });

  @override
  bool get isValid => error == null;
}

class FieldBloc<TValue> extends FieldBlocBase<FieldBlocState<TValue>, TValue> {
  final List<Validator<TValue>> _validators;

  FieldBloc({
    required TValue initialValue,
    List<Validator<TValue>> validators = const [],
  })  : _validators = validators,
        super(FieldBlocState(
          value: initialValue,
          error: _validate(validators, initialValue),
        ));

  @override
  void updateValue(TValue value) {
    emit(state.change((c) => c
      ..value = value
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
          value: adapter.from(fieldBloc.state.value),
          error: null,
        )) {
    _sub = fieldBloc.stream.listen((state) {
      final value = adapter.from(state.value);
      emit(FieldBlocState(
        value: value,
        error: state.error ?? _validate(value),
      ));
    });
  }

  @override
  void updateValue(TFine value) {
    fieldBloc.updateValue(_adapter.to(value));
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

  @override
  final List<TValue> value;
  @override
  final bool isValid;

  const ListFieldBlocState({
    required this.fieldBlocs,
    required this.value,
    required this.isValid,
  });
}

class ListFieldBloc<TValue> extends FieldBlocBase<ListFieldBlocState<TValue>, List<TValue>> {
  late final StreamSubscription _fieldBlocsSub;

  ListFieldBloc({
    List<FieldBlocBase<FieldBlocStateBase<TValue>, TValue>> fieldBlocs = const [],
  }) : super(ListFieldBlocState(
          fieldBlocs: fieldBlocs,
          value: fieldBlocs.map((e) => e.state.value).toList(),
          isValid: fieldBlocs.every((e) => e.state.isValid),
        )) {
    _fieldBlocsSub = stream.switchMap((state) {
      return Rx.combineLatestList(state.fieldBlocs.map((e) => e.hotStream));
    }).listen((states) {
      emit(state.change((c) => c
        ..value = states.map((e) => e.value).toList()
        ..isValid = states.every((e) => e.isValid)));
    });
  }

  void addFieldBlocs(List<FieldBlocBase<FieldBlocStateBase<TValue>, TValue>> fieldBlocs) {
    emit(state.change((c) => c.fieldBlocs = [...c.fieldBlocs, ...fieldBlocs]));
  }

  @override
  Future<void> close() async {
    await Future.wait(state.fieldBlocs.map((e) => e.close()));
    await _fieldBlocsSub.cancel();
    return super.close();
  }

  @override
  void updateValue(List<TValue> value) {
    // TODO: implement updateValue
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
