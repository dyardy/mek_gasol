import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:riverpod/riverpod.dart';

class PlayersTrigger {
  static final instance = Provider((ref) {
    return PlayersTrigger(ref);
  });

  final Ref _ref;

  FirebaseFirestore get _firestore => _ref.read(Providers.firestore);

  PlayersTrigger(this._ref);

  CollectionReference<PlayerDvo> get _players {
    return _firestore.collection('players').withConverter<PlayerDvo>(fromFirestore: (snapshot, _) {
      return PlayerDvo.fromJson({...snapshot.data()!, 'id': snapshot.id});
    }, toFirestore: (snapshot, _) {
      return {...snapshot.toJson()}..remove('id');
    });
  }

  Future<BuiltList<PlayerDvo>> readAll() async {
    final snapshot = await _players.get();
    return snapshot.docs.map((e) => e.data()).toBuiltList();
  }

  Stream<BuiltList<PlayerDvo>> watchAll() {
    return _players.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toBuiltList();
    });
  }

  Future<PlayerDvo> save({String? playerId, required String username}) async {
    final doc = _players.doc(playerId);
    final player = PlayerDvo(
      id: doc.id,
      username: username,
    );
    doc.set(player);
    return player;
  }

  Future<void> delete(PlayerDvo player) async {
    await _players.doc(player.id).delete();
  }
}
