import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'player_dvo.g.dart';

@DataClass()
@JsonSerializable()
class PlayerDvo with _$PlayerDvo {
  final String id;
  final String username;

  const PlayerDvo({
    required this.id,
    required this.username,
  });

  factory PlayerDvo.fromJson(Map<String, dynamic> map) => _$PlayerDvoFromJson(map);
  Map<String, dynamic> toJson() => _$PlayerDvoToJson(this);
}
