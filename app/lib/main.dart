import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/firebase_options.dart';
import 'package:mek_gasol/presentation/features/matches.dart';
import 'package:mek_gasol/presentation/features/players.dart';
import 'package:mek_gasol/shared/hub.dart';

void main() {
  // ignore: avoid_print
  print('0: This is a hester egg. Naa, I just have to try the CI. ');

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
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc)),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.map)),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return const MatchesScreen();
            case 1:
              return const PlayersScreen();
          }
          throw 'Not supported tab: $index';
        },
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
