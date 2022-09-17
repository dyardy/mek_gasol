// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$UserDto {
  UserDto get _self => this as UserDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.email;
    yield _self.displayName;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$UserDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('UserDto')
        ..add('id', _self.id)
        ..add('email', _self.email)
        ..add('displayName', _self.displayName))
      .toString();
}

mixin _$PublicUserDto {
  PublicUserDto get _self => this as PublicUserDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.displayName;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$PublicUserDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('PublicUserDto')
        ..add('id', _self.id)
        ..add('displayName', _self.displayName))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
    };

PublicUserDto _$PublicUserDtoFromJson(Map<String, dynamic> json) =>
    PublicUserDto(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$PublicUserDtoToJson(PublicUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
    };
