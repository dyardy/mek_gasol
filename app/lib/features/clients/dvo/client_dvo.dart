import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'client_dvo.g.dart';

@DataClass()
@JsonSerializable()
class ClientDvo with _$ClientDvo {
  final String id;
  final String displayName;

  const ClientDvo({
    required this.id,
    required this.displayName,
  });

  static const String displayNameKey = 'displayName';

  factory ClientDvo.fromJson(Map<String, dynamic> map) => _$ClientDvoFromJson(map);
  Map<String, dynamic> toJson() => _$ClientDvoToJson(this);
}
