import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/modules/gasol/features/players/repositories/players_repo.dart';
import 'package:riverpod/riverpod.dart';

class PlayersTrigger {
  static final instance = Provider((ref) {
    return PlayersTrigger(ref);
  });

  final Ref _ref;

  PlayersRepo get _playersRepo => _ref.read(PlayersRepo.instance);

  PlayersTrigger(this._ref);

  Future<List<PlayerDvo>> readAll() async => await _playersRepo.readAll();

  Stream<List<PlayerDvo>> watchAll() => _playersRepo.watchAll();

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
