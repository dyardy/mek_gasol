import 'package:built_collection/built_collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mek_gasol/features/matches/triggers/matches_trigger.dart';
import 'package:mek_gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/presentation/features/match.dart';
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

              String buildUsernames(BuiltList<PlayerDvo> players) {
                return players.map((e) => e.username).join(', ');
              }

              return AppListTile(
                onTap: () => Hub.push(MatchScreen(match: match)),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: buildUsernames(match.leftPlayers),
                        style: TextStyle(color: Colors.red),
                      ),
                      const TextSpan(
                        text: ' vs ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: buildUsernames(match.rightPlayers),
                        style: TextStyle(color: Colors.blue),
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
          onPressed: () => Hub.push(const MatchScreen(match: null)),
          child: const Text('Add'),
        ),
      ),
      child: matches,
    );
  }
}
