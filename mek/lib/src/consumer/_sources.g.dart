// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_sources.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides, unused_element

mixin _$StreamSource<T> {
  StreamSource<T> get _self => this as StreamSource<T>;

  Iterable<Object?> get _props sync* {
    yield _self.stream;
    yield _self.initialValue;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$StreamSource<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('StreamSource', [T])
        ..add('stream', _self.stream)
        ..add('initialValue', _self.initialValue))
      .toString();
}

mixin _$ListenableSource<T extends Listenable> {
  ListenableSource<T> get _self => this as ListenableSource<T>;

  Iterable<Object?> get _props sync* {
    yield _self.listenable;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ListenableSource<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() =>
      (ClassToString('ListenableSource', [T])..add('listenable', _self.listenable)).toString();
}

mixin _$ValueListenableSource<T> {
  ValueListenableSource<T> get _self => this as ValueListenableSource<T>;

  Iterable<Object?> get _props sync* {
    yield _self.valueListenable;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ValueListenableSource<T> &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() =>
      (ClassToString('ValueListenableSource', [T])..add('valueListenable', _self.valueListenable))
          .toString();
}
