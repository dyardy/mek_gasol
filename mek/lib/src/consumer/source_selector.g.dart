// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_selector.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$_SourceSelector<T, R> {
  _SourceSelector<T, R> get _self => this as _SourceSelector<T, R>;

  Iterable<Object?> get _props sync* {
    yield _self.source;
    yield _self.selector;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$_SourceSelector<T, R> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('_SourceSelector', [T, R])
        ..add('source', _self.source)
        ..add('selector', _self.selector))
      .toString();
}
