import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:riverpod/riverpod.dart';

class PlayersRepo {
  static final instance = Provider((ref) {
    return PlayersRepo(ref);
  });

  final Ref _ref;

  FirebaseFirestore get _firestore => _ref.read(Providers.firestore);

  PlayersRepo(this._ref);

  CollectionReference<PlayerDvo> get _collection {
    return _firestore.collection('players').withJsonConverter(PlayerDvo.fromJson);
  }

  Future<List<PlayerDvo>> readAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<PlayerDvo>> watchAll() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });
  }

  Future<PlayerDvo> save({String? playerId, required String username}) async {
    final doc = _collection.doc(playerId);
    final player = PlayerDvo(
      id: doc.id,
      username: username,
    );
    await doc.set(player);
    return player;
  }

  Future<void> delete(String playerId) async {
    await _collection.doc(playerId).delete();
  }
}
