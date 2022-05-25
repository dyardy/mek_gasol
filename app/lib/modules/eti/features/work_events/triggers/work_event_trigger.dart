import 'package:mek_gasol/modules/eti/features/work_events/dto/work_event_dto.dart';
import 'package:mek_gasol/modules/eti/features/work_events/dvo/work_event_dvo.dart';
import 'package:mek_gasol/modules/eti/features/work_events/repositories/work_event_repo.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tuple/tuple.dart';

class WorkEventTrigger {
  static final instance = Provider((ref) {
    return WorkEventTrigger._(ref);
  });

  final Ref _ref;

  WorkEventsRepo get _workEventsRepo => _ref.read(WorkEventsRepo.instance);

  WorkEventTrigger._(this._ref);

  static final month = StreamProvider.family((ref, Tuple2<String, DateTime> arg) {
    return ref.watch(WorkEventsRepo.instance).watchMonth(arg.item1, arg.item2);
  });

  Future<void> save(WorkEventDvo workEvent) async {
    await _workEventsRepo.create(WorkEventDto(
      id: workEvent.id,
      creatorUserId: workEvent.creatorUser.id,
      clientId: workEvent.client.id,
      projectId: workEvent.project.id,
      startAt: workEvent.startAt,
      endAt: workEvent.endAt,
      note: workEvent.note,
    ));
  }
}
