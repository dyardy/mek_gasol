import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/users/users_providers.dart';
import 'package:mek_gasol/modules/doof/shared/doof_formats.dart';
import 'package:mek_gasol/modules/doof/shared/navigation/routes.dart';
import 'package:mek_gasol/shared/logs/observers.dart';
import 'package:mek_gasol/shared/theme.dart';

/// Food app
class DoofApp extends StatelessWidget {
  const DoofApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      observers: [Observers.provider],
      child: _DoofApp(),
    );
  }
}

class _DoofApp extends ConsumerStatefulWidget {
  const _DoofApp({Key? key}) : super(key: key);

  @override
  ConsumerState<_DoofApp> createState() => _DoofAppState();
}

class _DoofAppState extends ConsumerState<_DoofApp> {
  final _authListenable = ValueNotifier<SingStatus?>(null);

  late final _router = GoRouter(
    routes: $appRoutes,
    redirect: _safeRedirect,
    refreshListenable: _authListenable,
    initialLocation: const SignInRoute().location,
  );

  @override
  void initState() {
    super.initState();
    ref.listenManual(UsersProviders.currentStatus, (previous, next) {
      _authListenable.value = next.valueOrNull;
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  String? _safeRedirect(BuildContext context, GoRouterState state) {
    final nextLocation = _redirect(context, state);
    return nextLocation == null || state.location == nextLocation ? null : nextLocation;
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    switch (_authListenable.value) {
      case null:
      case SingStatus.none:
        return const SignInRoute().location;
      case SingStatus.partial:
        return const SignUpDetailsRoute().location;
      case SingStatus.full:
        if (state.location.startsWith('/sign')) return const UserAreaRoute().location;
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
      routerConfig: _router,
    );
  }
}
