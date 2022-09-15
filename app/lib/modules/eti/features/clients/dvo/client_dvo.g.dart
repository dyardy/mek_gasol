// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_dvo.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$ClientDvo {
  ClientDvo get _self => this as ClientDvo;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.displayName;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$ClientDvo &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('ClientDvo')
        ..add('id', _self.id)
        ..add('displayName', _self.displayName))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientDvo _$ClientDvoFromJson(Map<String, dynamic> json) => ClientDvo(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$ClientDvoToJson(ClientDvo instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
    };
