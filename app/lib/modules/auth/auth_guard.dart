import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/shared/providers.dart';

class AuthGuard extends ConsumerWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AuthGuard({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(Providers.userStatus.select((value) => value.whenData((value) => value?.id)));

    return QueryViewBuilder<UserDto?>(
      bloc: get(),
      builder: (context, user) {
        return builder(context, user != null ? null : const SignInScreen());
      },
    );

    // return user.maybeWhen(data: (userId) {
    //   return builder(context, userId != null ? null : const SignInScreen());
    // }, orElse: () {
    //   return builder(context, const MekProgressIndicator());
    // });
  }
}
