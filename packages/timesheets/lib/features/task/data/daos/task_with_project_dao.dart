import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/task/task.dart';

part 'task_with_project_dao.g.dart';

@DriftAccessor(tables: [Tasks, Projects])
class TasksWithProjectDao extends DatabaseAccessor<AppDatabase>
    with _$TasksWithProjectDaoMixin {
  TasksWithProjectDao(AppDatabase db) : super(db);

  // Task with Projects CRUD operations
  Future<int> createTaskWithProject(
          TasksCompanion tasksCompanion, ProjectsCompanion projectsCompanion) =>
      transaction(() async {
        final projectId = await into(projects).insert(projectsCompanion);
        final taskId = await into(tasks).insert(tasksCompanion.copyWith(
          projectId: Value(projectId),
        ));

        return taskId;
      });

  Future<void> deleteTask(Task task) => delete(tasks).delete(task);

  Future<List<TaskWithProject>> get tasksWithProjects => (select(tasks)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ]))
      .join([
        leftOuterJoin(projects, projects.id.equalsExp(tasks.projectId)),
      ])
      .get()
      .then(
        (rows) => rows
            .map(
              (row) => TaskWithProject(
                task: row.readTable(tasks),
                project: row.readTable(projects),
              ),
            )
            .toList(),
      );
}
