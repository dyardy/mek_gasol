class Env {
  static const String name = String.fromEnvironment('name', defaultValue: 'dev');

  static const String prefix = name == 'prod' ? '' : '${name}_';
}
