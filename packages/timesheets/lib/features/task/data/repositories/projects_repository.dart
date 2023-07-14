import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

class ProjectsRepository {
  final ProjectsDao projectsDao;

  const ProjectsRepository(
    this.projectsDao,
  );

  Future<int> createProject(ProjectsCompanion projectsCompanion) =>
      projectsDao.createProject(projectsCompanion);
}
