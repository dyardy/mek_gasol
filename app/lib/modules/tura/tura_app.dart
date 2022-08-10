import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/auth/protected_area.dart';
import 'package:mek_gasol/modules/eti/features/calendar/screens/calendar_events.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';

/// Simple pizza App
class TuraApp extends StatelessWidget {
  const TuraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Hub.navigatorKey,
      locale: const Locale.fromSubtags(languageCode: 'it'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale.fromSubtags(languageCode: 'it')],
      debugShowCheckedModeBanner: false,
      title: 'Mek Gasol',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.highContrastDark(primary: Colors.yellow),
      ),
      builder: (context, child) => MaterialMekProvider(child: child!),
      home: ProtectedArea(
        authenticatedBuilder: (context) => const _AuthenticatedArea(),
      ),
    );
  }
}

enum _Tab { home }

final _tab = StateProvider((ref) => _Tab.home);

class _AuthenticatedArea extends ConsumerWidget {
  const _AuthenticatedArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(_tab);

    Widget buildTab() {
      switch (tab) {
        case _Tab.home:
          return const CalendarScreen();
      }
    }

    BottomNavigationBarItem buildBottomBarItem(_Tab tab) {
      switch (tab) {
        case _Tab.home:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          );
      }
    }

    return Scaffold(
      body: buildTab(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => ref.read(_tab.notifier).state = _Tab.values[index],
        items: _Tab.values.map(buildBottomBarItem).toList(),
      ),
    );
  }
}
