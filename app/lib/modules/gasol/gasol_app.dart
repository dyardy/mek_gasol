import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mek_gasol/presentation/features/matches.dart';
import 'package:mek_gasol/presentation/features/players.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';

class GasolApp extends StatelessWidget {
  const GasolApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      navigatorKey: Hub.navigatorKey,
      locale: const Locale.fromSubtags(languageCode: 'it'),
      localizationsDelegates: GlobalCupertinoLocalizations.delegates,
      supportedLocales: const [Locale.fromSubtags(languageCode: 'it')],
      title: 'Mek Gasol',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemOrange,
        primaryContrastingColor: CupertinoColors.systemYellow,
        brightness: Brightness.dark,
        // textTheme: CupertinoTextThemeData(
        //   primaryColor: CupertinoColors.systemYellow,
        // ),
      ),
      builder: (context, child) => CupertinoMekProvider(child: child!),
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
