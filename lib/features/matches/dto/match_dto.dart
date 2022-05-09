import 'package:built_collection/built_collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'match_dto.g.dart';

@DataClass()
@JsonSerializable()
class MatchDto with _$MatchDto {
  final String id;
  final DateTime createdAt;

  final BuiltList<String> leftPlayerIds;
  final BuiltList<String> rightPlayerIds;

  final int leftPoints;
  final int rightPoint;

  const MatchDto({
    required this.id,
    required this.createdAt,
    required this.leftPlayerIds,
    required this.rightPlayerIds,
    required this.leftPoints,
    required this.rightPoint,
  });

  factory MatchDto.fromJson(Map<String, dynamic> map) => _$MatchDtoFromJson(map);
  Map<String, dynamic> toJson() => _$MatchDtoToJson(this);
}
