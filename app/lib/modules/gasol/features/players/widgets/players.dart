import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/gasol/features/players/triggers/players_trigger.dart';
import 'package:mek_gasol/modules/gasol/features/players/widgets/player.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

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
      return const LoadingView();
    }, error: (error, _) {
      return ErrorView(error: error);
    }, data: (players) {
      return ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];

          return ListTile(
            onTap: () => context.hub.push(PlayerScreen(player: player)),
            title: Text(player.username),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Players'),
        actions: [
          IconButton(
            onPressed: () => context.hub.push(const PlayerScreen(player: null)),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        child: playersView,
      ),
    );
  }
}
