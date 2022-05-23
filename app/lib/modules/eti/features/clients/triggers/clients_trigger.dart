import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:riverpod/riverpod.dart';

class ClientsTrigger {
  static final instance = Provider((ref) {
    return ClientsTrigger(ref);
  });

  final Ref _ref;

  FirebaseFirestore get _firestore => _ref.read(Providers.firestore);

  ClientsTrigger(this._ref);

  CollectionReference<ClientDvo> get _collection {
    return _firestore.collection('clients').withJsonConverter(ClientDvo.fromJson);
  }

  Stream<BuiltList<ClientDvo>> watchAll() {
    final matchesQuery = _collection.orderBy(ClientDvo.displayNameKey, descending: false);

    return matchesQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toBuiltList();
    });
  }
}
