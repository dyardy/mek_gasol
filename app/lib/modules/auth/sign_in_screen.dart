import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/doof/shared/blocs.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/bloc_widgets.dart';
import 'package:mek_gasol/modules/doof/shared/widgets/button_builder.dart';
import 'package:mek_gasol/shared/form/fields/field_text.dart';
import 'package:mek_gasol/shared/form/form_blocs.dart';
import 'package:mek_gasol/shared/form/form_utils.dart';
import 'package:mek_gasol/shared/form/form_validators.dart';
import 'package:mek_gasol/shared/providers.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailFb = FieldBloc(
    initialValue: '',
    validators: [const TextValidation(isRequired: true)],
  );
  final _passwordFb = FieldBloc(
    initialValue: '',
    validators: [const TextValidation(isRequired: true)],
  );

  late final _form = ListFieldBloc(fieldBlocs: [_emailFb, _passwordFb]);

  final _signInMb = MutationBloc();

  void _submit() {
    _signInMb.handle(() async {
      _form.disable();

      final auth = ref.read(Providers.auth);

      await auth.signInWithEmailAndPassword(
        email: _emailFb.state.value,
        password: _passwordFb.state.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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

    Widget current = Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: buildFields(),
        ),
      ),
      floatingActionButton: ButtonBuilder(
        onPressed: _submit,
        mutationBlocs: {_signInMb},
        formBloc: _form,
        builder: (context, onPressed) {
          return AppFloatingActionButton(
            onPressed: onPressed,
            icon: const Icon(Icons.check),
            label: const Text('Sign In'),
          );
        },
      ),
    );
    current = BlocListener(
      bloc: _signInMb,
      listener: (context, state) {
        state.whenOrNull(failed: (error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$error'),
          ));
          _form.enable();
        });
      },
      child: current,
    );
    return current;
  }
}
