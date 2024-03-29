import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/auth/failures.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bottom_button_bar.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _signUpMb = MutationBloc();

  final _emailFb = FieldBloc(
    initialValue: '',
    validator: Validation.email,
  );
  final _passwordFb = FieldBloc(
    initialValue: '',
    validator: Validation.password,
  );
  final _passwordConfirmationFb = FieldBloc(
    initialValue: '',
    validator: Validation.password,
  );

  late final _form = ListFieldBloc(
    fieldBlocs: [_emailFb, _passwordFb, _passwordConfirmationFb],
  );

  void _signUp() {
    _signUpMb.handle(() async {
      if (_passwordFb.state.value != _passwordConfirmationFb.state.value) {
        throw PasswordsNotMatchFailure();
      }

      await get<FirebaseAuth>().createUserWithEmailAndPassword(
        email: _emailFb.state.value,
        password: _passwordFb.state.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.observe(_signUpMb.toSource(), (state) {
      state.whenOrNull(failed: (error) {
        if (error is FirebaseAuthException) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error.message ?? '$error'),
          ));
        } else if (error is PasswordsNotMatchFailure) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Passwords not match'),
          ));
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up!'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ButtonBuilder(
              onPressed: _signUp,
              mutationBlocs: {_signUpMb},
              formBloc: _form,
              builder: (context, onPressed) {
                return ElevatedButton(
                  onPressed: onPressed,
                  child: const Text('Viva Dart!'),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FieldText(
              fieldBloc: _emailFb,
              converter: FieldConvert.text,
              type: const TextFieldType.email(),
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            FieldText(
              fieldBloc: _passwordFb,
              converter: FieldConvert.text,
              type: const TextFieldType.password(),
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            FieldText(
              fieldBloc: _passwordConfirmationFb,
              converter: FieldConvert.text,
              type: const TextFieldType.password(),
              decoration: const InputDecoration(
                labelText: 'Password Confirmation',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
