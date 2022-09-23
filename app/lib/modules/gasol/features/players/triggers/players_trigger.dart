import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/modules/gasol/features/players/repositories/players_repo.dart';

class PlayersTrigger {
  PlayersRepo get _playersRepo => get();

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
