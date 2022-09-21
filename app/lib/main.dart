import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:mek_gasol/firebase_options.dart';
import 'package:mek_gasol/modules/doof/doof_app.dart';
import 'package:mek_gasol/modules/doof/shared/doof_migrations.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/init_doof_service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/eti/eti_app.dart';
import 'package:mek_gasol/modules/gasol/gasol_app.dart';
import 'package:mek_gasol/shared/logger.dart';
import 'package:mek_gasol/shared/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:version/version.dart';

void main() async {
  // ignore: avoid_print
  print('0: This is a hester egg. Naa, I just have to try the CI. ');

  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.initLogging();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = const _BlocObserver();

  await GetIt.instance.initDoofServiceLocator();

  runApp(const ProviderScope(
    observers: [_ProviderObserver()],
    child: Modules(),
  ));
}

enum ModulesStatus { loading, loaded, blocked }

enum Module {
  gasol('Biliardino App'),
  eti('Time tracker App'),
  doof('Wok Time App');

  const Module(this.description);

  final String description;
}

class Modules extends StatefulWidget {
  const Modules({Key? key}) : super(key: key);

  static ModulesState of(BuildContext context) => context.findAncestorStateOfType()!;

  @override
  State<Modules> createState() => ModulesState();
}

class ModulesState extends State<Modules> {
  var _status = ModulesStatus.loading;
  late SharedPreferences _preferences;
  Version? _currentVersion;
  Version? _targetVersion;
  Module? _module;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _currentVersion = Version.parse(packageInfo.version);
    _preferences = await SharedPreferences.getInstance();

    final firestore = get<FirebaseFirestore>();
    final appDoc = firestore.collection('apps').doc('doof');

    appDoc.snapshots().listen(_onAppDoc);
  }

  void _onAppDoc(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    _targetVersion = Version.parse(snapshot.data()!['version']);
    if (_targetVersion!.major > _currentVersion!.major) {
      setState(() {
        _status = ModulesStatus.blocked;
      });
      return;
    }

    final moduleName = _preferences.getString('$Module');
    final module = Module.values.firstWhereOrNull((e) => e.name == moduleName);
    setState(() {
      _module = module;
      _status = ModulesStatus.loaded;
    });
  }

  void select(Module? project) async {
    if (_module == project) return;
    if (project == null) {
      await _preferences.remove('$Module');
    } else {
      await _preferences.setString('$Module', project.name);
    }
    setState(() => _module = project);
  }

  @override
  Widget build(BuildContext context) {
    Widget? buildProject(ModulesStatus status) {
      switch (status) {
        case ModulesStatus.blocked:
          return const BlockApp();
        case ModulesStatus.loading:
        case ModulesStatus.loaded:
          break;
      }

      switch (_module) {
        case Module.gasol:
          return const GasolApp();
        case Module.eti:
          return const EtiApp();
        case Module.doof:
          return const DoofApp();
        case null:
          return const MaterialApp(
            home: _ModulesScreen(),
          );
      }
    }

    return ModulesScope(
      status: _status,
      currentVersion: _currentVersion,
      module: _module,
      targetVersion: _targetVersion,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: GestureDetector(
          onSecondaryLongPress: () => select(null),
          child: SizedBox.expand(
            child: buildProject(_status),
          ),
        ),
      ),
    );
  }
}

class ModulesScope extends InheritedWidget {
  final ModulesStatus status;
  final Version? currentVersion;
  final Version? targetVersion;
  final Module? module;

  const ModulesScope({
    super.key,
    required this.status,
    required this.currentVersion,
    required this.targetVersion,
    required this.module,
    required super.child,
  });

  static ModulesScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModulesScope>()!;
  }

  @override
  bool updateShouldNotify(ModulesScope oldWidget) {
    return status != oldWidget.status ||
        currentVersion != oldWidget.currentVersion ||
        targetVersion != oldWidget.targetVersion ||
        module != oldWidget.module;
  }
}

class _ModulesScreen extends StatelessWidget {
  const _ModulesScreen();

  @override
  Widget build(BuildContext context) {
    Widget buildBody() {
      final scope = ModulesScope.of(context);
      if (scope.status == ModulesStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          ...Module.values.map((e) {
            return ListTile(
              onTap: () => Modules.of(context).select(e),
              title: Text(e.name),
              subtitle: Text(e.description),
            );
          }).toList(),
          const Spacer(),
          if (kDebugMode)
            ListTile(
              onTap: () => DoofDatabase().migrateMenu(),
              title: const Text('Migrate Doof Menu'),
            ),
          if (kDebugMode)
            ListTile(
              onTap: () => DoofDatabase().migrateOrders(),
              title: const Text('Delete Doof Orders'),
            ),
          Text('Version: ${scope.currentVersion} -> ${scope.targetVersion}'),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modules'),
      ),
      body: buildBody(),
    );
  }
}

class BlockApp extends StatelessWidget {
  const BlockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doof App',
      theme: AppTheme.build(),
      home: const BlockScreen(),
    );
  }
}

class BlockScreen extends StatelessWidget {
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Text('Cretino! Aggiorna l\'app!'),
      ),
    );
  }
}

class _BlocObserver with BlocObserver {
  const _BlocObserver();

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
