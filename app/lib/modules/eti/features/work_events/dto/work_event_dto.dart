import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/clients/firebase/timestamp_json_converter.dart';

part 'work_event_dto.g.dart';

@DataClass()
@JsonSerializable()
@TimestampJsonConvert()
class WorkEventDto with _$WorkEventDto {
  final String id;
  final String creatorUserId;
  final String clientId;
  final String projectId;
  final DateTime startAt;
  final DateTime endAt;
  final String note;

  const WorkEventDto({
    required this.id,
    required this.clientId,
    required this.projectId,
    required this.creatorUserId,
    required this.startAt,
    required this.endAt,
    required this.note,
  });

  static const String startAtKey = 'startAt';
  static const String creatorUserIdKey = 'creatorUserId';

  factory WorkEventDto.fromJson(Map<String, dynamic> map) => _$WorkEventDtoFromJson(map);
  Map<String, dynamic> toJson() => _$WorkEventDtoToJson(this);
}
