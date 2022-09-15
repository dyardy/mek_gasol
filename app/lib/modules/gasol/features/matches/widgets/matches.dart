import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mek_gasol/modules/gasol/features/matches/triggers/matches_trigger.dart';
import 'package:mek_gasol/modules/gasol/features/matches/widgets/match.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/shared/app_list_tile.dart';
import 'package:mek_gasol/shared/hub.dart';

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
          return const CupertinoActivityIndicator();
        }, error: (error, _) {
          return const SizedBox.shrink();
        }, data: (matches) {
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];

              String buildUsernames(List<PlayerDvo> players) {
                return players.map((e) => e.username).join(', ');
              }

              return AppListTile(
                onTap: () => context.hub.push(MatchScreen(match: match)),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: buildUsernames(match.leftPlayers),
                        style: const TextStyle(color: CupertinoColors.systemRed),
                      ),
                      const TextSpan(text: ' vs '),
                      TextSpan(
                        text: buildUsernames(match.rightPlayers),
                        style: const TextStyle(color: CupertinoColors.systemBlue),
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

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Matches'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.hub.push(const MatchScreen(match: null)),
          child: const Text('Add'),
        ),
      ),
      child: matches,
    );
  }
}
