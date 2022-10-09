import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/init_doof_service_locator.dart';
import 'package:mek_gasol/packages/firebase_options.dart';
import 'package:mek_gasol/shared/logger.dart';
import 'package:mek_gasol/shared/logs/observers.dart';
import 'package:mek_gasol/shared/widgets/guards/modules_guard.dart';
import 'package:mek_gasol/shared/widgets/guards/version_guard.dart';

void main() async {
  // ignore: avoid_print
  print('0: This is a hester egg. Naa, I just have to try the CI. ');

  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.initLogging();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = Observers.bloc;

  await GetIt.instance.initDoofServiceLocator();

  runApp(const VersionGuard(
    child: ModulesGuard(
      current: Module.doof,
    ),
  ));
}
