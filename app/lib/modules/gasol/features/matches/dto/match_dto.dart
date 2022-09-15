import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/clients/firebase/timestamp_json_converter.dart';

part 'match_dto.g.dart';

@DataClass()
@JsonSerializable()
@TimestampJsonConvert()
class MatchDto with _$MatchDto {
  final String id;
  final DateTime createdAt;

  final List<String> leftPlayerIds;
  final List<String> rightPlayerIds;

  final int leftPoints;
  final int rightPoint;

  static const String createdAtKey = 'createdAt';

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
