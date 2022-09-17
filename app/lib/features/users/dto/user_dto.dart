import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'user_dto.g.dart';

@DataClass()
@JsonSerializable()
class UserDto with _$UserDto implements PublicUserDto {
  @override
  final String id;
  final String email;
  @override
  final String displayName;
  // final String avatarUrl;

  const UserDto({
    required this.id,
    required this.email,
    required this.displayName,
    // required this.avatarUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> map) => _$UserDtoFromJson(map);
  @override
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@DataClass()
@JsonSerializable()
class PublicUserDto with _$PublicUserDto {
  final String id;
  final String displayName;
  // final String avatarUrl;

  const PublicUserDto({
    required this.id,
    required this.displayName,
    // required this.avatarUrl,
  });

  factory PublicUserDto.fromJson(Map<String, dynamic> map) => _$PublicUserDtoFromJson(map);
  Map<String, dynamic> toJson() => _$PublicUserDtoToJson(this);
}
