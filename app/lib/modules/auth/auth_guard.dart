import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
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

    return user.maybeWhen(data: (userId) {
      return builder(context, userId != null ? null : const SignInScreen());
    }, orElse: () {
      return builder(context, const MekProgressIndicator());
    });
  }
}
