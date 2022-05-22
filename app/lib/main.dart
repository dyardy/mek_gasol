import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/firebase_options.dart';
import 'package:mek_gasol/presentation/features/calendar.dart';
import 'package:mek_gasol/presentation/features/matches.dart';
import 'package:mek_gasol/presentation/features/players.dart';
import 'package:mek_gasol/shared/app_list_tile.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      child: Projects(),
    ));
  }, blocObserver: _BlocObserver());
}

class GasolProject extends StatelessWidget {
  const GasolProject({Key? key}) : super(key: key);

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

class EtiProject extends StatelessWidget {
  const EtiProject({Key? key}) : super(key: key);

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
      home: const CalendarScreen(),
    );
  }
}

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  Project? _project;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final preferences = await SharedPreferences.getInstance();
    final projectName = preferences.getString('$Project');
    final project = Project.values.firstWhere(orElse: () => Project.gasol, (e) {
      return e.name == projectName;
    });
    setState(() => _project = project);
  }

  void change(Project project) async {
    if (_project == project) return;
    setState(() => _project = null);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('$Project', project.name);
    setState(() => _project = project);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildProject() {
      switch (_project) {
        case Project.gasol:
          return const GasolProject();
        case Project.eti:
          return const EtiProject();
        case null:
          return Column(
            children: Project.values.map((e) {
              return AppListTile(
                onTap: () => change(e),
                title: Text(e.name),
              );
            }).toList(),
          );
      }
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onSecondaryLongPress: () => setState(() => _project = null),
        child: SizedBox.expand(
          child: _buildProject(),
        ),
      ),
    );
  }
}

enum Project { gasol, eti }

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
