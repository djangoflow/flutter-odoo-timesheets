import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

export 'task_pagination_filter.dart';

class ProjectListCubit extends CrudListCubit<Task, TaskPaginationFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  ProjectListCubit({required super.repository});
}
