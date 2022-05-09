import 'package:built_collection/built_collection.dart';
import 'package:mek_gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/features/players/repos/players_repo.dart';
import 'package:riverpod/riverpod.dart';

class PlayersTrigger {
  static final instance = Provider((ref) {
    return PlayersTrigger(ref);
  });

  final Ref _ref;

  PlayersRepo get _playersRepo => _ref.read(PlayersRepo.instance);

  PlayersTrigger(this._ref);

  Future<BuiltList<PlayerDvo>> readAll() async => await _playersRepo.readAll();

  Stream<BuiltList<PlayerDvo>> watchAll() => _playersRepo.watchAll();

  Future<PlayerDvo> save({required String? playerId, required String username}) async {
    return await _playersRepo.save(
      playerId: playerId,
      username: username,
    );
  }

  Future<void> delete(PlayerDvo player) async {
    await _playersRepo.delete(player.id);
  }
}
