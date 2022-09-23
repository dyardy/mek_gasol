import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/gasol/features/players/triggers/players_trigger.dart';
import 'package:mek_gasol/modules/gasol/features/players/widgets/player.dart';
import 'package:mek_gasol/shared/data/query_view_builder.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({Key? key}) : super(key: key);

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final _playersQb = QueryBloc(() {
    return get<PlayersTrigger>().watchAll();
  });

  @override
  Widget build(BuildContext context) {
    final playersView = QueryViewBuilder(
      bloc: _playersQb,
      builder: (context, players) {
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
      },
    );

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
