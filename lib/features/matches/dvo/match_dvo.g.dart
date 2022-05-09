// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_dvo.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$MatchDvo {
  MatchDvo get _self => this as MatchDvo;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.createdAt;
    yield _self.leftPlayers;
    yield _self.rightPlayers;
    yield _self.leftPoints;
    yield _self.rightPoints;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$MatchDvo &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('MatchDvo')
        ..add('id', _self.id)
        ..add('createdAt', _self.createdAt)
        ..add('leftPlayers', _self.leftPlayers)
        ..add('rightPlayers', _self.rightPlayers)
        ..add('leftPoints', _self.leftPoints)
        ..add('rightPoints', _self.rightPoints))
      .toString();
}
