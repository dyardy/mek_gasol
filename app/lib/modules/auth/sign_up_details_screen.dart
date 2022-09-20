import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/users/repositories/users_repo.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bottom_button_bar.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class SignUpDetailsScreen extends StatefulWidget {
  const SignUpDetailsScreen({super.key});

  @override
  State<SignUpDetailsScreen> createState() => _SignUpDetailsScreenState();
}

class _SignUpDetailsScreenState extends State<SignUpDetailsScreen> {
  final _signUpMb = MutationBloc();

  final _displayNameFb = FieldBloc(
    initialValue: '',
    validators: [const TextValidation(isRequired: true)],
  );

  void _signUp() {
    _signUpMb.handle(() async {
      await get<UsersRepository>().create(
        displayName: _displayNameFb.state.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Sign Up!'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ButtonBuilder(
              onPressed: _signUp,
              mutationBlocs: {_signUpMb},
              formBloc: _displayNameFb,
              builder: (context, onPressed) {
                return ElevatedButton(
                  onPressed: onPressed,
                  child: const Text('Viva Flutter!'),
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
              fieldBloc: _displayNameFb,
              converter: FieldConvert.text,
              decoration: const InputDecoration(
                labelText: 'Display Name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
