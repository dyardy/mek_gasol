import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/stream_consumer_base.dart';

class AuthGuard extends StatelessWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AuthGuard({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialValue: FirebaseAuth.instance.currentUser,
      builder: (context, user) {
        return builder(context, user != null ? null : const SignInScreen());
      },
    );
  }
}
