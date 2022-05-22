import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';

part 'work_event_dvo.g.dart';

@DataClass()
class WorkEventDvo with _$WorkEventDvo {
  final String id;
  final UserDto creatorUser;
  final DateTime startAt;
  final DateTime endAt;
  final String note;

  const WorkEventDvo({
    required this.id,
    required this.creatorUser,
    required this.startAt,
    required this.endAt,
    required this.note,
  });
}
