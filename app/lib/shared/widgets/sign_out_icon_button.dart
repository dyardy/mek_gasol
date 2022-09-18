import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/main.dart';

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
            onTap: () => Modules.of(context).select(null),
            child: const Text('Change App'),
          ),
        ];
      },
    );
  }
}
