import 'package:flutter/material.dart';
import 'package:mek_gasol/features/users/users_providers.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/modules/auth/sign_up_details_screen.dart';
import 'package:mek_gasol/modules/doof/shared/riverpod.dart';

class AuthGuard extends StatelessWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AuthGuard({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AsyncViewBuilder(
      provider: UsersProviders.currentStatus,
      builder: (context, ref, status) {
        switch (status) {
          case SingStatus.none:
            return builder(context, const SignInScreen());
          case SingStatus.partial:
            return builder(context, const SignUpDetailsScreen());
          case SingStatus.full:
            return builder(context, null);
        }
      },
    );
  }
}
