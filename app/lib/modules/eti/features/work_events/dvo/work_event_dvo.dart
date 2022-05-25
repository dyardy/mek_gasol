import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';

part 'work_event_dvo.g.dart';

@DataClass()
class WorkEventDvo with _$WorkEventDvo {
  final String id;
  final UserDto creatorUser;
  final ClientDvo client;
  final ProjectDvo project;
  final DateTime startAt;
  final DateTime endAt;
  final String note;

  const WorkEventDvo({
    required this.id,
    required this.creatorUser,
    required this.client,
    required this.project,
    required this.startAt,
    required this.endAt,
    required this.note,
  });
}
