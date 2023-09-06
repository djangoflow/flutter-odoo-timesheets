import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';

abstract class ProjectRepository
    extends CrudRepository<Project, ProjectPaginatedFilter> {}
