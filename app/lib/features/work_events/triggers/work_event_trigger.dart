import 'package:built_collection/built_collection.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/features/users/repositories/users_repo.dart';
import 'package:mek_gasol/features/work_events/dto/work_event_dto.dart';
import 'package:mek_gasol/features/work_events/dvo/work_event_dvo.dart';
import 'package:mek_gasol/features/work_events/repositories/work_event_repo.dart';
import 'package:riverpod/riverpod.dart';
import 'package:rxdart/rxdart.dart';

class WorkEventTrigger {
  static final instance = Provider((ref) {
    return WorkEventTrigger(ref);
  });

  final Ref _ref;

  UsersRepo get _usersRepo => _ref.read(UsersRepo.instance);
  WorkEventsRepo get _workEventsRepo => _ref.read(WorkEventsRepo.instance);

  WorkEventTrigger(this._ref);

  Stream<BuiltList<WorkEventDvo>> watchMonth(String userId, DateTime month) {
    return Rx.combineLatest2<BuiltList<UserDto>, BuiltList<WorkEventDto>, BuiltList<WorkEventDvo>>(
        _usersRepo.watchAll(), _workEventsRepo.watchMonth(userId, month), (users, events) {
      return events.map((event) {
        return WorkEventDvo(
          id: event.id,
          creatorUser: users.firstWhere((user) => event.creatorUserId == user.id),
          startAt: event.startAt,
          endAt: event.endAt,
          note: event.note,
        );
      }).toBuiltList();
    });
  }

  Future<void> save(WorkEventDvo workEvent) async {
    await _workEventsRepo.create(WorkEventDto(
      id: workEvent.id,
      creatorUserId: workEvent.creatorUser.id,
      startAt: workEvent.startAt,
      endAt: workEvent.endAt,
      note: workEvent.note,
    ));
  }
}
