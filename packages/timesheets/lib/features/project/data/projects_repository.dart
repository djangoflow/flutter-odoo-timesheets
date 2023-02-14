import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;

///Repository to communicate with odoo external_api using xml_rpc
class ProjectRepository {
  static final ProjectRepository _instance = ProjectRepository._internal();

  factory ProjectRepository() => _instance;

  ProjectRepository._internal();

  final OdooRepository _baseRepo = OdooRepository();

  /// Performs various operations like read, search, update, add, edit data
  /// based on [model], [methods] and parameters
  Future getProjects(
    int id,
    String password,
  ) async {
    var response = await _baseRepo.getObject(
      id,
      password,
      'project.project',
      'search_read',
      [],
      optionalParams: _baseRepo.buildFilterableFields(['name']),
    );

    List<Project> projects = [];
    for (final project in response) {
      projects.add(Project.fromJson(project));
    }
    return projects;
  }

  ///Handles errors generated due to various operations in [OdooRepository] using [OdooRepositoryException]
  handleError(error) {
    if (error.runtimeType == xml_rpc.Fault) {
      throw OdooRepositoryException(error.text);
    } else {
      throw const OdooRepositoryException();
    }
  }
}
