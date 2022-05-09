import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/matches/triggers/matches_trigger.dart';
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

              return AppListTile(
                title: Text('${match.createdAt}'),
              );
            },
          );
        });
      },
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
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
