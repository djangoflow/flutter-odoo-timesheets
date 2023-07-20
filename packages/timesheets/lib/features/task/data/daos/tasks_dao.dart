import 'package:drift/drift.dart';
import 'package:timesheets/features/app/data/db/app_database.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/project/project.dart';
import 'package:timesheets/features/task/task.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks, Projects, ExternalProjects, ExternalTasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(AppDatabase db) : super(db);

  // Task CRUD operations
  Future<int> createTask(TasksCompanion tasksCompanion) =>
      into(tasks).insert(tasksCompanion);

  Future<int> createTaskWithProject(
          TasksCompanion tasksCompanion, ProjectsCompanion projectsCompanion) =>
      transaction(
        () async {
          final projectId = await into(projects).insert(projectsCompanion);
          final taskId = await into(tasks).insert(
            tasksCompanion.copyWith(
              projectId: Value(projectId),
            ),
          );

          return taskId;
        },
      );

  Future<List<TaskWithProjectExternalData>> getPaginatedTasksWithProjects(
      {required int limit, int? offset, int? projectId}) {
    final query = select(tasks)
      // should be ordered by createdAt and onlineIds
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
      ])
      ..limit(limit, offset: offset);
    if (projectId != null) {
      query.where((t) => t.projectId.equals(projectId));
    }

    return (query)
        .join([
          leftOuterJoin(
              externalTasks, tasks.id.equalsExp(externalTasks.internalId)),
          leftOuterJoin(projects, tasks.projectId.equalsExp(projects.id)),
          leftOuterJoin(externalProjects,
              projects.id.equalsExp(externalProjects.internalId)),
        ])
        .get()
        .then(
          (rows) => rows
              .map(
                (row) => _rowTaskWithProjectExternalData(row),
              )
              .toList(),
        );
  }

  Future<List<TaskWithProjectExternalData>> getAllTasksWithProjects() =>
      (select(tasks)
            // should be ordered by createdAt and onlineIds
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
            ]))
          .join([
            leftOuterJoin(
                externalTasks, tasks.id.equalsExp(externalTasks.internalId)),
            leftOuterJoin(projects, tasks.projectId.equalsExp(projects.id)),
            leftOuterJoin(externalProjects,
                projects.id.equalsExp(externalProjects.internalId)),
          ])
          .get()
          .then(
            (rows) => rows
                .map(
                  (row) => _rowTaskWithProjectExternalData(row),
                )
                .toList(),
          );

  Future<Task?> getTaskById(int taskId) =>
      (select(tasks)..where((t) => t.id.equals(taskId))).getSingleOrNull();
  // it should fetch Task with ExternalTask(nullable) and then the Project and ExternalProject(nullable) and map it to TaskWithProjectExternalData
  Future<TaskWithProjectExternalData?> getTaskWithProjectById(int taskId) =>
      (select(tasks)..where((t) => t.id.equals(taskId)))
          .join(
            [
              leftOuterJoin(
                  externalTasks, tasks.id.equalsExp(externalTasks.internalId)),
              leftOuterJoin(projects, tasks.projectId.equalsExp(projects.id)),
              leftOuterJoin(externalProjects,
                  projects.id.equalsExp(externalProjects.internalId)),
            ],
          )
          .getSingleOrNull()
          .then(
            (row) {
              if (row == null) {
                return null;
              } else {
                return _rowTaskWithProjectExternalData(row);
              }
            },
          );

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Future<List<Task>> getPaginatedTasks(int limit, int? offset) => (select(tasks)
        ..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
        ])
        ..limit(limit, offset: offset))
      .get();

  Future<void> updateTask(Task task) => update(tasks).replace(task);

  Future<int> deleteTask(Task task) => delete(tasks).delete(task);

  Future<List<Task>> getTasksByIds(List<int> taskIds) => (select(tasks)
        ..where(
          (t) => t.id.isIn(taskIds),
        ))
      .get();

  TaskWithProjectExternalData _rowTaskWithProjectExternalData(TypedResult row) {
    final task = row.readTable(tasks);
    final externalTask = row.readTableOrNull(externalTasks);
    final project = row.readTable(projects);
    final externalProject = row.readTableOrNull(externalProjects);

    final taskWithExternalData = TaskWithExternalData(
      task: task,
      externalTask: externalTask,
    );

    final projectWithExternalData = ProjectWithExternalData(
      project: project,
      externalProject: externalProject,
    );

    return TaskWithProjectExternalData(
      taskWithExternalData: taskWithExternalData,
      projectWithExternalData: projectWithExternalData,
    );
  }

  Future<void> batchUpdateTasks(List<Task> tasks) async {
    await batch((batch) {
      batch.insertAll(
        this.tasks,
        tasks,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> createTaskWithExternal({
    required TasksCompanion tasksCompanion,
    required ExternalTasksCompanion externalTasksCompanion,
  }) async {
    await transaction(() async {
      final id = await createTask(tasksCompanion);
      await into(externalTasks).insert(
        externalTasksCompanion.copyWith(
          internalId: Value(id),
        ),
      );
    });
  }

  Future<List<Task>> getTasksByProjectIds(List<int> projectIds) =>
      (select(tasks)
            ..where(
              (t) => t.projectId.isIn(projectIds),
            ))
          .get();
}
