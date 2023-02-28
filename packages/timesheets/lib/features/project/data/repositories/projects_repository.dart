import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';

///Repository to fetch projects data using [OdooRepository]
class ProjectRepository extends OdooRpcRepositoryBase {
  ProjectRepository(super.rpcClient);

  Future<List<Project>> getProjects([ProjectListFilter? filter]) async {
    Map<String, dynamic> optionalParams = buildFilterableFields(['name']);
    if(filter!=null) {
      optionalParams.addAll({
        offset: filter.offset,
        limit: filter.limit,
      });
    }

    var response = await odooCallMethod(
      odooModel: projectModel,
      method: OdooApiMethod.searchRead.name,
      parameters: [
        [],
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
