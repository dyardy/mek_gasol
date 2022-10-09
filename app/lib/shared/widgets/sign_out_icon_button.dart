import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/shared/widgets/guards/modules_guard.dart';

class SignOutIconButton extends StatelessWidget {
  const SignOutIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.logout),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => FirebaseAuth.instance.signOut(),
            child: const Text('Sign Out'),
          ),
          PopupMenuItem(
            onTap: () => ModulesGuard.of(context).select(null),
            child: const Text('Change App'),
          ),
        ];
      },
    );
  }
}
