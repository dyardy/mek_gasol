import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/eti/features/projects/blocs/projects_bloc.dart';
import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';
import 'package:riverbloc/riverbloc.dart';
import 'package:rivertion/rivertion.dart';

final _form = BlocProvider.autoDispose((ref) {
  return TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );
});

final _save = MutationProvider.family.autoDispose((ref, String clientId) {
  return MutationBloc((param) {
    final clients = ref.read(ProjectsBloc.instance);
    final formBloc = ref.read(_form.bloc);

    final project = ProjectDvo(
      id: '',
      name: formBloc.value,
    );
    clients.save(clientId, project);
  });
});

class ProjectScreen extends ConsumerWidget {
  final String clientId;

  const ProjectScreen({
    Key? key,
    required this.clientId,
  }) : super(key: key);

  void save(WidgetRef ref) {
    ref.read(_save(clientId).bloc).maybeMutate(null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formBloc = ref.watch(_form.bloc);

    ref.listen<MutationState>(_save(clientId), (previous, next) {
      next.mapOrNull(success: (_) {
        Hub.pop();
      });
    });

    final buttonBar = Consumer(
      builder: (context, ref, _) {
        final canSave = ref.watch(_save(clientId).select((state) => !state.isMutating));
        final canSubmit = ref.watch(_form.select((state) {
          return !state.hasUpdatedValue && !state.isValidating;
        }));

        return AppFloatingActionButton(
          onPressed: canSave && canSubmit ? () => save(ref) : null,
          icon: const Icon(Icons.check),
          label: const Text('Save'),
          // child: const Icon(Icons.check),
        );
      },
    );

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Add Project'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFieldBlocBuilder(
              textFieldBloc: formBloc,
            ),
          ],
        ),
      ),
      floatingActionButton: buttonBar,
    );
  }
}
