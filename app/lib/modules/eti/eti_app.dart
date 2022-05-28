import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/modules/eti/features/calendar/screens/calendar_events.dart';
import 'package:mek_gasol/modules/eti/features/calendar/screens/calendar_rules.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/providers.dart';

class EtiApp extends StatelessWidget {
  const EtiApp({Key? key}) : super(key: key);

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
      home: const _ProtectedArea(),
    );
  }
}

class _ProtectedArea extends ConsumerWidget {
  const _ProtectedArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(Providers.userStatus.select((value) => value.whenData((value) => value?.id)));

    return user.maybeWhen(data: (userId) {
      if (userId == null) {
        return const SignInScreen();
      }
      return const _AuthenticatedArea();
    }, orElse: () {
      return const Material(
        child: MekProgressIndicator(),
      );
    });
  }
}

enum _Tab { events, rules }

final _tab = StateProvider((ref) => _Tab.events);

class _AuthenticatedArea extends ConsumerWidget {
  const _AuthenticatedArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(_tab);

    Widget _buildTab() {
      switch (tab) {
        case _Tab.events:
          return const CalendarScreen();
        case _Tab.rules:
          return const CalendarRuleScreen();
      }
    }

    BottomNavigationBarItem _buildBottomBarItem(_Tab tab) {
      switch (tab) {
        case _Tab.events:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          );
        case _Tab.rules:
          return const BottomNavigationBarItem(
            icon: Icon(Icons.rule),
            label: 'Rules',
          );
      }
    }

    return Scaffold(
      body: _buildTab(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => ref.read(_tab.notifier).state = _Tab.values[index],
        items: _Tab.values.map(_buildBottomBarItem).toList(),
      ),
    );
  }
}
