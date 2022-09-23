import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/gasol/features/matches/triggers/matches_trigger.dart';
import 'package:mek_gasol/modules/gasol/features/matches/widgets/match.dart';
import 'package:mek_gasol/modules/gasol/features/players/dvo/player_dvo.dart';
import 'package:mek_gasol/shared/data/query_view_builder.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final _matchesQb = QueryBloc(() {
    return get<MatchesTrigger>().watchAll();
  });

  @override
  Widget build(BuildContext context) {
    final matches = QueryViewBuilder(
      bloc: _matchesQb,
      builder: (context, matches) {
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
