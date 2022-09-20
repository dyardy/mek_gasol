class RequiredValidation<T> extends Validation<T?> {
  const RequiredValidation();

  @override
  List<Object> call(T? value) {
    if (value == null) return const ['Field is required.'];
    return [];
  }
}

class TextValidation extends Validation<String> {
  final bool isRequired;
  final int? minLength;

  const TextValidation({
    this.isRequired = false,
    this.minLength,
  });

  @override
  List<Object> call(String value) {
    if (value.isEmpty) return const ['Field is required.'];
    return [];
  }
}

class StringToIntegerValidator extends Validation<String> {
  const StringToIntegerValidator();

  @override
  List<Object> call(String value) {
    final fineValue = int.tryParse(value);
    if (fineValue == null) return ['Not valid int'];
    return [];
  }
}

class IntegerValidator extends Validation<int> {
  final int min;

  const IntegerValidator({required this.min});

  @override
  List<Object> call(int value) {
    if (value < min) return ['Min value is $min'];
    return [];
  }
}

class NoValidator<T> extends Validation<T> {
  const NoValidator();
  @override
  List<Object> call(T value) => [];
}

abstract class Validation<T> {
  const Validation();

  List<Object> call(T value);
}

typedef Validator<T> = List<Object> Function(T value);
