import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/players/triggers/players_trigger.dart';
import 'package:mek_gasol/presentation/features/player.dart';
import 'package:mek_gasol/shared/app_list_tile.dart';
import 'package:mek_gasol/shared/hub.dart';

class PlayersBloc {
  static final all = StreamProvider((ref) {
    return ref.watch(PlayersTrigger.instance).watchAll();
  });
}

class PlayersScreen extends ConsumerWidget {
  const PlayersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersState = ref.watch(PlayersBloc.all);

    final playersView = playersState.when(loading: () {
      return const CupertinoActivityIndicator();
    }, error: (error, _) {
      return const SizedBox.shrink();
    }, data: (players) {
      return ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];

          return AppListTile(
            onTap: () => Hub.push(PlayerScreen(player: player)),
            title: Text(player.username),
          );
        },
      );
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Players'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Hub.push(const PlayerScreen(player: null)),
          child: const Text('Add'),
        ),
      ),
      child: SafeArea(
        child: playersView,
      ),
    );
  }
}
