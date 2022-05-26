import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/features/firestore/repositories/firestore_repository.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/dto/calendar_event_dto.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:riverpod/riverpod.dart';

class EventsCalendarRepo extends FirestoreRepository<EventCalendarDto> {
  static final instance = Provider((ref) {
    return EventsCalendarRepo(ref);
  });

  EventsCalendarRepo(Ref ref)
      : super(FirestoreContext(
          ref: ref,
          collectionName: 'events_calendar',
          fromFirestore: EventCalendarDto.fromJson,
        ));

  Stream<BuiltList<EventCalendarDto>> watchMonth(String userId, DateTime month) {
    final nextMonth = DateTimeUtils.darwinAdd(month, 1);

    var query = context.collection.asQuery();

    query = query.orderBy(EventCalendarDto.startAtKey);
    query = query.startAt([Timestamp.fromDate(month)]).endAt([Timestamp.fromDate(nextMonth)]);
    query = query.where(EventCalendarDto.createdByKey, isEqualTo: userId);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toBuiltList();
    });
  }
}
