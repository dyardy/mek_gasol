import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class VersionGuard extends StatefulWidget {
  final Widget child;

  const VersionGuard({
    super.key,
    required this.child,
  });

  @override
  State<VersionGuard> createState() => _VersionGuardState();
}

class _VersionGuardState extends State<VersionGuard> {
  bool _isBlocked = false;
  Version? _currentVersion;
  Version? _minVersion;

  @override
  void initState() {
    super.initState();
    if (kReleaseMode) _checkVersion();
  }

  // "version" field in the document is deprecated
  void _checkVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _currentVersion = Version.parse(packageInfo.version);

    final firestore = get<FirebaseFirestore>();
    final appDoc = firestore.collection('apps').doc('doof');
    appDoc.snapshots().listen(_onAppDoc);
  }

  void _onAppDoc(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    _minVersion = Version.parse(snapshot.data()!['minVersion']);

    if (_currentVersion! >= _minVersion!) return;

    setState(() {
      _isBlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isBlocked) {
      return MaterialApp(
        title: 'Doof App',
        theme: AppTheme.build(),
        home: _BlockedScreen(
          currentVersion: _currentVersion!,
          targetVersion: _minVersion!,
        ),
      );
    }

    return widget.child;
  }
}

class _BlockedScreen extends StatelessWidget {
  final Version currentVersion;
  final Version targetVersion;

  const _BlockedScreen({
    required this.currentVersion,
    required this.targetVersion,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text(
          'Cretino! Aggiorna l\'app!\n'
          'Current: $currentVersion\n'
          'MinVersion: $targetVersion',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
