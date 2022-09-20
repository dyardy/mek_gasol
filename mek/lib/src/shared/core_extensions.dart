import 'package:collection/collection.dart';

extension EqualsMap<K, V> on Map<K, V> {
  bool equals(Map<K, V> other) => const MapEquality().equals(this, other);
}
