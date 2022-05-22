import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/features/work_events/dto/work_event_dto.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:riverpod/riverpod.dart';

class WorkEventsRepo {
  static final instance = Provider((ref) {
    return WorkEventsRepo(ref);
  });

  final Ref _ref;

  FirebaseFirestore get _firestore => _ref.read(Providers.firestore);

  WorkEventsRepo(this._ref);

  CollectionReference<WorkEventDto> get _collection {
    return _firestore.collection('work_events').withJsonConverter(WorkEventDto.fromJson);
  }

  Stream<BuiltList<WorkEventDto>> watchMonth(String userId, DateTime month) {
    final nextMonth = DateTimeUtils.darwinAdd(month, 1);

    var query = _collection.asQuery();

    query = query.orderBy(WorkEventDto.startAtKey);
    query = query.startAt([Timestamp.fromDate(month)]).endAt([Timestamp.fromDate(nextMonth)]);
    query = query.where(WorkEventDto.creatorUserIdKey, isEqualTo: userId);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toBuiltList();
    });
  }

  Future<void> create(WorkEventDto workEvent) async {
    final doc = _collection.doc();
    await doc.set(workEvent);
  }
}
