import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mek_gasol/modules/gasol/features/matches/widgets/matches.dart';
import 'package:mek_gasol/modules/gasol/features/players/widgets/players.dart';
import 'package:mek_gasol/shared/theme.dart';

/// Statistics Foosball table App
class GasolApp extends StatelessWidget {
  const GasolApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale.fromSubtags(languageCode: 'it'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale.fromSubtags(languageCode: 'it')],
      title: 'Mek Gasol',
      theme: AppTheme.build(),
      home: const _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home();

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  var _tabIndex = 0;

  void changeTab(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: changeTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_tree_outlined), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.supervisor_account_outlined), label: 'Players'),
        ],
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: const [
          MatchesScreen(),
          PlayersScreen(),
        ],
      ),
    );
  }
}
