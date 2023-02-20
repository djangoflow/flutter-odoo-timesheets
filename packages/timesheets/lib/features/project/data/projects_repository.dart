import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_method.dart';
import 'package:timesheets/features/project/project.dart';

///Repository to fetch projects data using [OdooRepository]
class ProjectRepository extends OdooRpcRepositoryBase {
  Future getProjects({
    required int id,
    required String password,
  }) async {
    var response = await getObject(
      id,
      password,
      projectMethod,
      OdooApiMethod.searchRead.name,
      [],
      optionalParams: buildFilterableFields(['name']),
    );

    List<Project> projects = [];
    for (final project in response) {
      projects.add(Project.fromJson(project));
    }
    return projects;
  }
}
