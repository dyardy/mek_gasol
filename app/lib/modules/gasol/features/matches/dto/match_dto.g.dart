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

MatchDto _$MatchDtoFromJson(Map json) => MatchDto(
      id: json['id'] as String,
      createdAt:
          const TimestampJsonConvert().fromJson(json['createdAt'] as Timestamp),
      leftPlayerIds: ((json['leftPlayerIds'] as List).map((e) => e as String))
          .toBuiltList(),
      rightPlayerIds: ((json['rightPlayerIds'] as List).map((e) => e as String))
          .toBuiltList(),
      leftPoints: json['leftPoints'] as int,
      rightPoint: json['rightPoint'] as int,
    );

Map<String, dynamic> _$MatchDtoToJson(MatchDto instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': const TimestampJsonConvert().toJson(instance.createdAt),
      'leftPlayerIds': instance.leftPlayerIds.toList(),
      'rightPlayerIds': instance.rightPlayerIds.toList(),
      'leftPoints': instance.leftPoints,
      'rightPoint': instance.rightPoint,
    };
