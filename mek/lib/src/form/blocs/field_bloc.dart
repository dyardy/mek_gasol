import 'package:bloc/bloc.dart';
import 'package:mek/src/form/form_validators.dart';
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

class FieldBloc<TValue> extends FieldBlocBase<FieldBlocState<TValue>, TValue> {
  final List<Validator<TValue>> _validators;

  FieldBloc({
    required TValue initialValue,
    List<Validator<TValue>> validators = const [],
  })  : _validators = validators,
        super(FieldBlocState(
          isEnabled: true,
          isTouched: false,
          initialValue: initialValue,
          value: initialValue,
          // isChanged: false,
          errors: _validate(validators, initialValue),
        ));

  @override
  void changeValue(TValue value) {
    emit(state.change((c) => c
      ..value = value
      ..isTouched = true
      ..errors = _validate(_validators, value)));
  }

  @override
  void updateValue(TValue? value) {
    final effectiveValue = value is! TValue ? state.initialValue : value;
    emit(state.change((c) => c
      ..value = effectiveValue
      ..isTouched = false
      ..errors = _validate(_validators, effectiveValue)));
  }

  @override
  void updateInitialValue(TValue value) {
    emit(state.change((c) => c
      ..initialValue = value
      ..value = value
      ..isTouched = false
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

  @override
  void touch() => emit(state.change((c) => c..isTouched = true));
}
