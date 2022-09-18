import 'package:flutter/material.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';

class AuthGuard extends StatelessWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AuthGuard({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: get<QueryBloc<UserDto?>>(),
      builder: (context, state) {
        if (state.isLoading) {
          return const Material(child: Center(child: CircularProgressIndicator()));
        }
        return builder(context, state.data != null ? null : const SignInScreen());
      },
    );
    // return ValueStreamBuilder(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   initialValue: FirebaseAuth.instance.currentUser,
    //   builder: (context, user) {
    //     return builder(context, user != null ? null : const SignInScreen());
    //   },
    // );
  }
}
