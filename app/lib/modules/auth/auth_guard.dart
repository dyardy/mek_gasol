import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/modules/auth/sign_up_details_screen.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';

class AuthGuard extends StatelessWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AuthGuard({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: get<FirebaseAuth>().authStateChanges(),
      initialValue: null,
      builder: (context, authUser) {
        return BlocBuilder(
          bloc: get<QueryBloc<UserDto?>>(),
          builder: (context, state) {
            if (state.isLoading) {
              return const Material(child: Center(child: CircularProgressIndicator()));
            }
            if (authUser == null) {
              return builder(context, const SignInScreen());
            }
            if (state.dataOrNull == null) {
              return builder(context, const SignUpDetailsScreen());
            }
            return builder(context, null);
          },
        );
      },
    );
  }
}
