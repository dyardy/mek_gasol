import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/auth/sign_in_screen.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/providers.dart';

class ProtectedArea extends ConsumerWidget {
  final WidgetBuilder authenticatedBuilder;

  const ProtectedArea({
    Key? key,
    required this.authenticatedBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(Providers.userStatus.select((value) => value.whenData((value) => value?.id)));

    return user.maybeWhen(data: (userId) {
      if (userId == null) {
        return const SignInScreen();
      }
      return authenticatedBuilder(context);
    }, orElse: () {
      return const MekProgressIndicator();
    });
  }
}
