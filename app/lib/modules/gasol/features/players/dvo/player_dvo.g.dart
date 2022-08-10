// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_dvo.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$PlayerDvo {
  PlayerDvo get _self => this as PlayerDvo;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.username;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$PlayerDvo &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('PlayerDvo')
        ..add('id', _self.id)
        ..add('username', _self.username))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerDvo _$PlayerDvoFromJson(Map json) => PlayerDvo(
      id: json['id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$PlayerDvoToJson(PlayerDvo instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
    };
