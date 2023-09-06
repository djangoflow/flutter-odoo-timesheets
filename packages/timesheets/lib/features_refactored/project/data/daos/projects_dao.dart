import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features_refactored/app/data/dao.dart';

abstract class ProjectsDao extends Dao<Project, ProjectsCompanion> {
  @override
  Future<List<Project>> getPaginatedEntities({
    int? offset,
    int? limit,
    String? search,
    bool? isFavorite,
  });
}
