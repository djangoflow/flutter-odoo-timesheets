import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/project.dart';

class ProjectListCubit extends CrudListCubit<Project, ProjectPaginatedFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  ProjectListCubit({required super.repository});
}
