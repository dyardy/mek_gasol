import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/players/triggers/players_trigger.dart';
import 'package:mek_gasol/firebase_options.dart';
import 'package:mek_gasol/presentation/features/player.dart';
import 'package:mek_gasol/shared/app_list_tile.dart';
import 'package:mek_gasol/shared/hub.dart';

void main() {
  BlocOverrides.runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const ProviderScope(
      observers: [_ProviderObserver()],
      child: MyApp(),
    ));
  }, blocObserver: _BlocObserver());
}

class PlayersBloc {
  static final all = StreamProvider((ref) {
    return ref.watch(PlayersTrigger.instance).watchAll();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      navigatorKey: Hub.navigatorKey,
      title: 'Mek Gasol',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemOrange,
        primaryContrastingColor: CupertinoColors.systemYellow,
        brightness: Brightness.dark,
        // textTheme: CupertinoTextThemeData(
        //   primaryColor: CupertinoColors.systemYellow,
        // ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
        trailing: CupertinoButton(
          onPressed: () => Hub.push(const PlayerScreen(player: null)),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: playersView,
      ),
    );
  }
}

class _BlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('bloc:${bloc.runtimeType}:$bloc\n$error\n$stackTrace');
  }
}

class _ProviderObserver extends ProviderObserver {
  const _ProviderObserver();

  @override
  void didUpdateProvider(
      ProviderBase provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    if (newValue is AsyncError) {
      debugPrint('riverpod:$provider\n${newValue.error}\n${newValue.stackTrace}');
    }
  }

  @override
  void providerDidFail(
      ProviderBase provider, Object error, StackTrace stackTrace, ProviderContainer container) {
    super.providerDidFail(provider, error, stackTrace, container);
    debugPrint('riverpod:$provider\n$error\n$stackTrace');
  }
}
