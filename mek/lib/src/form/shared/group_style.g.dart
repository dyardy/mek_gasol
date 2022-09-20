// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_style.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$FlexGroupStyle {
  FlexGroupStyle get _self => this as FlexGroupStyle;

  Iterable<Object?> get _props sync* {
    yield _self.direction;
    yield _self.textDirection;
    yield _self.verticalDirection;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$FlexGroupStyle &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('FlexGroupStyle')
        ..add('direction', _self.direction)
        ..add('textDirection', _self.textDirection)
        ..add('verticalDirection', _self.verticalDirection))
      .toString();
}

mixin _$TableGroupStyle {
  TableGroupStyle get _self => this as TableGroupStyle;

  Iterable<Object?> get _props sync* {
    yield _self.textDirection;
    yield _self.mainVerticalDirection;
    yield _self.crossVerticalDirection;
    yield _self.crossAxisCount;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$TableGroupStyle &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('TableGroupStyle')
        ..add('textDirection', _self.textDirection)
        ..add('mainVerticalDirection', _self.mainVerticalDirection)
        ..add('crossVerticalDirection', _self.crossVerticalDirection)
        ..add('crossAxisCount', _self.crossAxisCount))
      .toString();
}

mixin _$WrapGroupStyle {
  WrapGroupStyle get _self => this as WrapGroupStyle;

  Iterable<Object?> get _props sync* {
    yield _self.direction;
    yield _self.alignment;
    yield _self.spacing;
    yield _self.runAlignment;
    yield _self.runSpacing;
    yield _self.crossAxisAlignment;
    yield _self.textDirection;
    yield _self.verticalDirection;
    yield _self.clipBehavior;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$WrapGroupStyle &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('WrapGroupStyle')
        ..add('direction', _self.direction)
        ..add('alignment', _self.alignment)
        ..add('spacing', _self.spacing)
        ..add('runAlignment', _self.runAlignment)
        ..add('runSpacing', _self.runSpacing)
        ..add('crossAxisAlignment', _self.crossAxisAlignment)
        ..add('textDirection', _self.textDirection)
        ..add('verticalDirection', _self.verticalDirection)
        ..add('clipBehavior', _self.clipBehavior))
      .toString();
}

mixin _$ListGroupStyle {
  ListGroupStyle get _self => this as ListGroupStyle;

  Iterable<Object?> get _props sync* {
    yield _self.controller;
    yield _self.primary;
    yield _self.scrollDirection;
    yield _self.reverse;
    yield _self.physics;
    yield _self.height;
    yield _self.width;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ListGroupStyle &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('ListGroupStyle')
        ..add('controller', _self.controller)
        ..add('primary', _self.primary)
        ..add('scrollDirection', _self.scrollDirection)
        ..add('reverse', _self.reverse)
        ..add('physics', _self.physics)
        ..add('height', _self.height)
        ..add('width', _self.width))
      .toString();
}

mixin _$GridGroupStyle {
  GridGroupStyle get _self => this as GridGroupStyle;

  Iterable<Object?> get _props sync* {
    yield _self.controller;
    yield _self.primary;
    yield _self.scrollDirection;
    yield _self.reverse;
    yield _self.physics;
    yield _self.gridDelegate;
    yield _self.height;
    yield _self.width;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$GridGroupStyle &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('GridGroupStyle')
        ..add('controller', _self.controller)
        ..add('primary', _self.primary)
        ..add('scrollDirection', _self.scrollDirection)
        ..add('reverse', _self.reverse)
        ..add('physics', _self.physics)
        ..add('gridDelegate', _self.gridDelegate)
        ..add('height', _self.height)
        ..add('width', _self.width))
      .toString();
}
