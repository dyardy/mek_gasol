import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/firebase_options.dart';
import 'package:mek_gasol/modules/eti/eti_app.dart';
import 'package:mek_gasol/modules/gasol/gasol_app.dart';
import 'package:mek_gasol/modules/tura/tura_app.dart';
import 'package:mek_gasol/shared/app_list_tile.dart';
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
      child: Modules(),
    ));
  }, blocObserver: _BlocObserver());
}

enum Module { gasol, eti, tura }

class Modules extends StatefulWidget {
  const Modules({Key? key}) : super(key: key);

  @override
  State<Modules> createState() => _ModulesState();
}

class _ModulesState extends State<Modules> {
  var _isLoading = true;
  Module? _module;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final preferences = await SharedPreferences.getInstance();
    final moduleName = preferences.getString('$Module');
    final module = Module.values.firstWhere(orElse: () => Module.gasol, (e) {
      return e.name == moduleName;
    });
    setState(() {
      _module = module;
      _isLoading = false;
    });
  }

  void change(Module project) async {
    if (_module == project) return;
    setState(() => _module = null);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('$Module', project.name);
    setState(() => _module = project);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildProject() {
      switch (_module) {
        case Module.gasol:
          return const GasolApp();
        case Module.eti:
          return const EtiApp();
        case Module.tura:
          return const TuraApp();
        case null:
          return Column(
            children: Module.values.map((e) {
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
        onSecondaryLongPress: () => setState(() => _module = null),
        child: SizedBox.expand(
          child: _isLoading ? null : buildProject(),
        ),
      ),
    );
  }
}

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
