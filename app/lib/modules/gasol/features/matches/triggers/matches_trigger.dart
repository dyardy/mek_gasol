import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/modules/gasol/features/matches/dto/match_dto.dart';
import 'package:mek_gasol/modules/gasol/features/matches/dvo/match_dvo.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/modules/gasol/features/players/repositories/players_repo.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:riverpod/riverpod.dart';
import 'package:rxdart/rxdart.dart';

class MatchesTrigger {
  static final instance = Provider((ref) {
    return MatchesTrigger(ref);
  });

  final Ref _ref;

  FirebaseFirestore get _firestore => _ref.read(Providers.firestore);

  MatchesTrigger(this._ref);

  CollectionReference<MatchDto> get _collection {
    return _firestore.collection('matches').withJsonConverter(MatchDto.fromJson);
  }

  Future<void> save({
    required String? matchId,
    required List<PlayerDvo> leftPlayers,
    required List<PlayerDvo> rightPlayers,
    required int leftPoints,
    required int rightPoint,
  }) async {
    final doc = _collection.doc(matchId);
    final match = MatchDto(
      id: doc.id,
      createdAt: DateTime.now(),
      leftPlayerIds: leftPlayers.map((e) => e.id).toList(),
      rightPlayerIds: rightPlayers.map((e) => e.id).toList(),
      leftPoints: leftPoints,
      rightPoint: rightPoint,
    );
    await doc.set(match);
  }

  Stream<List<MatchDvo>> watchAll() {
    final playersStream = _ref.watch(PlayersRepo.instance).watchAll();

    final matchesQuery = _collection.orderBy(MatchDto.createdAtKey, descending: true);
    final matchesStream = matchesQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });

    return Rx.combineLatest2<List<PlayerDvo>, List<MatchDto>, List<MatchDvo>>(
        playersStream, matchesStream, (players, matches) {
      return matches.map((match) {
        return MatchDvo(
          id: match.id,
          createdAt: match.createdAt,
          leftPlayers: players.where((e) => match.leftPlayerIds.contains(e.id)).toList(),
          rightPlayers: players.where((e) => match.rightPlayerIds.contains(e.id)).toList(),
          leftPoints: match.leftPoints,
          rightPoints: match.rightPoint,
        );
      }).toList();
    });
  }
}
