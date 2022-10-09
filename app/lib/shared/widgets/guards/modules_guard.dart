import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/doof_app.dart';
import 'package:mek_gasol/modules/doof/shared/doof_migrations.dart';
import 'package:mek_gasol/shared/env.dart';
import 'package:mek_gasol/shared/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Module {
  // gasol('Biliardino App'),
  // eti('Time tracker App'),
  doof('Wok Time App');

  const Module(this.description);

  final String description;
}

class ModulesGuard extends StatefulWidget {
  final Module? current;

  const ModulesGuard({
    Key? key,
    this.current,
  }) : super(key: key);

  static ModulesGuardState of(BuildContext context) => context.findAncestorStateOfType()!;

  @override
  State<ModulesGuard> createState() => ModulesGuardState();
}

class ModulesGuardState extends State<ModulesGuard> {
  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();
  late bool _isLoading;
  Module? _module;

  @override
  void initState() {
    super.initState();
    _module = widget.current;
    if (_module == null) {
      _isLoading = true;
      _loadModule();
    } else {
      _isLoading = false;
    }
  }

  void _loadModule() async {
    final moduleName = (await _preferences).getString('$Module');
    final module = Module.values.firstWhereOrNull((e) => e.name == moduleName);
    setState(() {
      _isLoading = false;
      _module = module;
    });
  }

  void select(Module? project) async {
    if (_module == project) return;
    if (project == null) {
      await (await _preferences).remove('$Module');
    } else {
      await (await _preferences).setString('$Module', project.name);
    }
    setState(() => _module = project);
  }

  @override
  Widget build(BuildContext context) {
    Widget? buildProject() {
      switch (_module) {
        // case Module.gasol:
        //   return const GasolApp();
        // case Module.eti:
        //   return const EtiApp();
        case Module.doof:
          return const DoofApp();
        case null:
          return MaterialApp(
            theme: AppTheme.build(),
            home: _ModulesScreen(
              isLoading: _isLoading,
            ),
          );
      }
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox.expand(
        child: buildProject(),
      ),
    );
  }
}

class _ModulesScreen extends StatelessWidget {
  final bool isLoading;

  const _ModulesScreen({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    Widget buildBody() {
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          ...Module.values.map((e) {
            return ListTile(
              onTap: () => ModulesGuard.of(context).select(e),
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
          //  | Version: ${scope.currentVersion} -> ${scope.targetVersion}
          const Text('Env: ${Env.name}'),
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
