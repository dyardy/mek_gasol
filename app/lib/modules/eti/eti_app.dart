import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/modules/eti/features/work_events/calendar.dart';
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
      title: 'Mek Gasol',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.highContrastDark(primary: Colors.yellow),
      ),
      builder: (context, child) => MaterialMekProvider(child: child!),
      home: const _AuthArea(),
    );
  }
}

class _AuthArea extends ConsumerWidget {
  const _AuthArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(Providers.userStatus.select((value) => value.whenData((value) => value?.id)));

    return user.maybeWhen(data: (userId) {
      if (userId == null) {
        return const SignInScreen();
      }
      return const CalendarScreen();
    }, orElse: () {
      return const Material(
        child: MekProgressIndicator(),
      );
    });
  }
}
