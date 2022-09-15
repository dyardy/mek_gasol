// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

// ignore_for_file: annotate_overrides

mixin _$MatchDto {
  MatchDto get _self => this as MatchDto;

  Iterable<Object?> get _props sync* {
    yield _self.id;
    yield _self.createdAt;
    yield _self.leftPlayerIds;
    yield _self.rightPlayerIds;
    yield _self.leftPoints;
    yield _self.rightPoint;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _$MatchDto &&
          runtimeType == other.runtimeType &&
          DataClass.$equals(_props, other._props);

  int get hashCode => Object.hashAll(_props);

  String toString() => (ClassToString('MatchDto')
        ..add('id', _self.id)
        ..add('createdAt', _self.createdAt)
        ..add('leftPlayerIds', _self.leftPlayerIds)
        ..add('rightPlayerIds', _self.rightPlayerIds)
        ..add('leftPoints', _self.leftPoints)
        ..add('rightPoint', _self.rightPoint))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchDto _$MatchDtoFromJson(Map<String, dynamic> json) => MatchDto(
      id: json['id'] as String,
      createdAt:
          const TimestampJsonConvert().fromJson(json['createdAt'] as Timestamp),
      leftPlayerIds: (json['leftPlayerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rightPlayerIds: (json['rightPlayerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      leftPoints: json['leftPoints'] as int,
      rightPoint: json['rightPoint'] as int,
    );

Map<String, dynamic> _$MatchDtoToJson(MatchDto instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': const TimestampJsonConvert().toJson(instance.createdAt),
      'leftPlayerIds': instance.leftPlayerIds,
      'rightPlayerIds': instance.rightPlayerIds,
      'leftPoints': instance.leftPoints,
      'rightPoint': instance.rightPoint,
    };
