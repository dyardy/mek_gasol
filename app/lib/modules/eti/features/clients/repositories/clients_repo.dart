import 'package:built_collection/built_collection.dart';
import 'package:mek_gasol/features/firestore/repositories/firestore_repository.dart';
import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:riverpod/riverpod.dart';

class ClientsRepo extends FirestoreRepository<ClientDvo> {
  static final instance = Provider((ref) {
    return ClientsRepo(ref);
  });

  ClientsRepo(Ref ref)
      : super(FirestoreContext(
          ref: ref,
          collectionName: 'clients',
          fromFirestore: ClientDvo.fromJson,
        ));

  Stream<BuiltList<ClientDvo>> watchAll() {
    final matchesQuery = context.collection.orderBy(ClientDvo.displayNameKey, descending: false);

    return matchesQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toBuiltList();
    });
  }
}