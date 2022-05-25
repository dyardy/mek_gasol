import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';
import 'package:mek_gasol/modules/eti/features/projects/repositories/projects_repo.dart';
import 'package:riverpod/riverpod.dart';

class ProjectsTrigger {
  static final instance = Provider((ref) {
    return ProjectsTrigger._(ref);
  });

  final Ref _ref;

  ProjectsRepo get _projects => _ref.watch(ProjectsRepo.instance);

  ProjectsTrigger._(this._ref);

  Future<void> save(String clientId, ProjectDvo project) async {
    await _projects.save(clientId, project);
  }

  static final all = StreamProvider.family((ref, String clientId) {
    final projects = ref.watch(ProjectsRepo.instance);

    return projects.watchAll(clientId);
  });
}
