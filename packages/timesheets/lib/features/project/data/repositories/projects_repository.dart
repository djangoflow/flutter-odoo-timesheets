import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';

///Repository to fetch projects data using [OdooRepository]
class ProjectRepository extends OdooRpcRepositoryBase {
  ProjectRepository(super.rpcClient);

  Future<List<Project>> getProjects([ProjectListFilter? filter]) async {
    Map<String, dynamic> optionalParams = buildFilterableFields([name]);
    if (filter != null) {
      optionalParams.addAll({
        offset: filter.offset,
        limit: filter.limit,
      });
    }
    final requiredParameters = [];
    if (filter != null && filter.search != null) {
      requiredParameters.add([
        [
          name,
          caseInsensitiveComparison,
          '${filter.search}%',
        ],
      ]);
    }

    var response = await odooCallMethod(
      odooModel: projectModel,
      method: OdooApiMethod.searchRead.name,
      parameters: [
        requiredParameters,
        optionalParams,
      ],
    );

    final projects = <Project>[];
    for (final project in response) {
      projects.add(Project.fromJson(project));
    }
    return projects;
  }
}
