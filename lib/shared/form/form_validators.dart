class StringValidator {
  Object? call(String value) {
    return null;
  }
}

class StringToIntegerValidator extends ValidatorBase<String> {
  const StringToIntegerValidator();

  @override
  Object? call(String value) {
    final fineValue = int.tryParse(value);
    if (fineValue == null) return 'Not valid int';
    return null;
  }
}

class IntegerValidator extends ValidatorBase<int> {
  final int min;

  const IntegerValidator({required this.min});

  @override
  Object? call(int value) {
    if (value < min) return 'Min value is $min';
    return null;
  }
}

class NoValidator<T> extends ValidatorBase<T> {
  const NoValidator();
  @override
  Object? call(T value) => null;
}

abstract class ValidatorBase<T> {
  const ValidatorBase();
  Object? call(T value);
}

typedef Validator<T> = Object? Function(T value);
