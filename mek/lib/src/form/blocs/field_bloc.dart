import 'package:bloc/bloc.dart';
import 'package:mek/src/form/validation/validation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'field_bloc.g.dart';

abstract class FieldBlocStateBase<TValue> {
  bool get isEnabled;
  bool get isTouched;
  TValue get value;
  bool get isInitial;
  List<Object> get errors;

  const FieldBlocStateBase();

  bool get isValid => errors.isEmpty;
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

  void touch();
}

typedef FieldBlocRule<TValue> = FieldBlocBase<FieldBlocStateBase<TValue>, TValue>;

@DataClass(changeable: true)
class FieldBlocState<TValue> extends FieldBlocStateBase<TValue> with _$FieldBlocState<TValue> {
  @override
  final bool isEnabled;
  @override
  final bool isTouched;
  final TValue initialValue;
  @override
  final TValue value;

  @override
  final List<Object> errors;

  const FieldBlocState({
    required this.isEnabled,
    required this.isTouched,
    required this.initialValue,
    required this.value,
    required this.errors,
  });

  @override
  bool get isInitial => initialValue == value;
}

Object? _validateNothing(dynamic _) => null;

class FieldBloc<TValue> extends FieldBlocBase<FieldBlocState<TValue>, TValue> {
  Validator<TValue> _validator;

  FieldBloc({
    required TValue initialValue,
    Validator<TValue> validator = _validateNothing,
  })  : _validator = validator,
        super(FieldBlocState(
          isEnabled: true,
          isTouched: false,
          initialValue: initialValue,
          value: initialValue,
          // isChanged: false,
          errors: _validate(validator, initialValue),
        ));

  @override
  void changeValue(TValue value) {
    emit(state.change((c) => c
      ..value = value
      ..isTouched = true
      ..errors = _validate(_validator, value)));
  }

  @override
  void updateValue(TValue? value) {
    final effectiveValue = value is! TValue ? state.initialValue : value;
    emit(state.change((c) => c
      ..value = effectiveValue
      ..isTouched = false
      ..errors = _validate(_validator, effectiveValue)));
  }

  @override
  void updateInitialValue(TValue value) {
    emit(state.change((c) => c
      ..initialValue = value
      ..value = value
      ..isTouched = false
      ..errors = _validate(_validator, value)));
  }

  void updateValidator(Validator<TValue> validator) {
    _validator = validator;
    emit(state.change((c) => c..errors = _validate(validator, state.value)));
  }

  static List<Object> _validate<T>(Validator<T> validator, T value) {
    final error = validator(value);
    return error == null ? [] : [error];
  }

  @override
  void disable() => emit(state.change((c) => c..isEnabled = false));

  @override
  void enable() => emit(state.change((c) => c..isEnabled = true));

  @override
  void touch() => emit(state.change((c) => c..isTouched = true));
}
