import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mek_gasol/modules/gasol/features/matches/triggers/matches_trigger.dart';
import 'package:mek_gasol/modules/gasol/features/matches/widgets/match.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

abstract class MatchesBloc {
  static final all = StreamProvider((ref) {
    return ref.watch(MatchesTrigger.instance).watchAll();
  });
}

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matches = Consumer(
      builder: (context, ref, _) {
        final matches = ref.watch(MatchesBloc.all);
        return matches.when(loading: () {
          return const LoadingView();
        }, error: (error, _) {
          return ErrorView(error: error);
        }, data: (matches) {
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];

              String buildUsernames(List<PlayerDvo> players) {
                return players.map((e) => e.username).join(', ');
              }

              return ListTile(
                onTap: () => context.hub.push(MatchScreen(match: match)),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: buildUsernames(match.leftPlayers),
                        style: const TextStyle(color: Colors.red),
                      ),
                      const TextSpan(text: ' vs '),
                      TextSpan(
                        text: buildUsernames(match.rightPlayers),
                        style: const TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                ),
                subtitle: Text(DateFormat.yMd().add_Hm().format(match.createdAt)),
                trailing: Text('${match.leftPoints} - ${match.rightPoints}'),
              );
            },
          );
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Matches'),
        actions: [
          IconButton(
            onPressed: () => context.hub.push(const MatchScreen(match: null)),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: matches,
    );
  }
}
