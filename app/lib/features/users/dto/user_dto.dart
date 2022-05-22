import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'user_dto.g.dart';

@DataClass()
@JsonSerializable()
class UserDto with _$UserDto {
  final String id;
  final String email;

  const UserDto({
    required this.id,
    required this.email,
  });

  factory UserDto.fromJson(Map<String, dynamic> map) => _$UserDtoFromJson(map);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
