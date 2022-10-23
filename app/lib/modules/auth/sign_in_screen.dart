import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/auth/sign_up_screen.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailFb = FieldBloc(
    initialValue: '',
    validator: Validation.email,
  );
  final _passwordFb = FieldBloc(
    initialValue: '',
    validator: const TextValidation(minLength: 1),
  );

  late final _form = ListFieldBloc(fieldBlocs: [_emailFb, _passwordFb]);

  final _signInMb = MutationBloc();

  void _submit() {
    _signInMb.handle(() async {
      _form.disable();

      await get<FirebaseAuth>().signInWithEmailAndPassword(
        email: _emailFb.state.value,
        password: _passwordFb.state.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.observe(_signInMb.toSource(), (state) {
      state.whenOrNull(failed: (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$error'),
        ));
        _form.enable();
      });
    });

    List<Widget> buildFields() {
      return [
        FieldText(
          fieldBloc: _emailFb,
          converter: FieldConvert.text,
          type: const TextFieldType.email(),
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        FieldText(
          fieldBloc: _passwordFb,
          converter: FieldConvert.text,
          type: const TextFieldType.password(),
          decoration: const InputDecoration(labelText: 'Password'),
        ),
      ];
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Sign In'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...buildFields(),
            const SizedBox(height: 16.0),
            ButtonBuilder(
              onPressed: _submit,
              mutationBlocs: {_signInMb},
              formBloc: _form,
              builder: (context, onPressed) {
                return ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.login),
                  label: const Text('Sign In'),
                );
              },
            ),
            const SizedBox(height: 16.0),
            ButtonBuilder(
              onPressed: () => context.hub.push(const SignUpScreen()),
              mutationBlocs: {_signInMb},
              builder: (context, onPressed) {
                return OutlinedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.app_registration),
                  label: const Text('Sign Up'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
