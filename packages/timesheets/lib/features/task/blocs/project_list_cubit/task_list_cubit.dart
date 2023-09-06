import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

export 'task_paginated_filter.dart';

class ProjectListCubit extends CrudListCubit<Task, TaskPaginatedFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  ProjectListCubit({required super.repository});
}
