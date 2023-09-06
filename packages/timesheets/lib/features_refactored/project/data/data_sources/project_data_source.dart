import 'package:timesheets/features_refactored/app/data/data_source.dart';
import 'package:timesheets/features_refactored/project/data/entities/project_entity.dart';

abstract class ProjectDataSource extends DataSource<ProjectEntity> {
  @override
  Future<List<ProjectEntity>> getPaginatedItems({
    int? offset,
    int? limit,
    String? search,
    bool? isFavorite,
  });
}
