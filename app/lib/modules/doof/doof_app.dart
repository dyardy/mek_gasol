import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/auth/auth_guard.dart';
import 'package:mek_gasol/modules/doof/shared/doof_formats.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/user_area.dart';
import 'package:mek_gasol/shared/theme.dart';

/// Food app
class DoofApp extends StatelessWidget {
  const DoofApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      builder: (context, child) => MaterialApp(
        key: ValueKey(child),
        locale: const Locale.fromSubtags(languageCode: 'it'),
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          ValidationLocalizations(),
          DoofFormats.delegate,
        ],
        supportedLocales: const [Locale.fromSubtags(languageCode: 'it')],
        debugShowCheckedModeBanner: false,
        title: 'Doof App',
        theme: AppTheme.build(),
        home: child ?? const UserArea(),
      ),
    );
  }
}
