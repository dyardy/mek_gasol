import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/rivertion.dart';

abstract class SignInBloc {
  static final form = BlocProvider.autoDispose<_SignInFormBloc, GroupFieldBlocState>((ref) {
    return _SignInFormBloc();
  });

  static final signIn = MutationProvider.autoDispose<void, void>((ref) {
    return MutationBloc((param) async {
      final auth = ref.watch(Providers.auth);
      final formBloc = ref.read(form.bloc);

      await auth.signInWithEmailAndPassword(
        email: formBloc.emailFB.value,
        password: formBloc.passwordFB.value,
      );
    });
  });
}

class _SignInFormBloc extends GroupFieldBloc {
  final emailFB = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );
  final passwordFB = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars,
    ],
  );

  _SignInFormBloc() {
    addAll({
      'email': emailFB,
      'password': passwordFB,
    });
  }
}

class SignInScreen extends ConsumerWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formBloc = ref.watch(SignInBloc.form.bloc);
    final authState = ref.watch(SignInBloc.signIn);

    List<Widget> _buildFields() {
      return [
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.emailFB,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: formBloc.passwordFB,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
      ];
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (authState is FailedMutation<void>) Text('${authState.error}'),
            ..._buildFields(),
          ],
        ),
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed:
            authState.isMutating ? null : () => ref.read(SignInBloc.signIn.bloc).maybeMutate(null),
        icon: const Icon(Icons.check),
        label: const Text('Sign In'),
      ),
    );
  }
}
