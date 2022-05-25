import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:mek_gasol/modules/eti/features/clients/repositories/clients_repo.dart';
import 'package:riverpod/riverpod.dart';

class ClientsTrigger {
  static final instance = Provider((ref) {
    return ClientsTrigger._(ref);
  });

  final Ref _ref;

  ClientsRepo get _clients => _ref.read(ClientsRepo.instance);

  ClientsTrigger._(this._ref);

  Future<void> save(ClientDvo client) async {
    if (client.id.isEmpty) {
      await _clients.create(client);
    } else {
      await _clients.update(client);
    }
  }

  Future<void> delete(String clientId) async {
    await _clients.delete(clientId);
  }

  static final all = StreamProvider((ref) {
    final clientsRepo = ref.watch(ClientsRepo.instance);

    return clientsRepo.watchAll();
  });
}
