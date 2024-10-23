// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:djangoflow_sync_drift_odoo/src/database/database.drift.dart'
    as i1;
import 'package:timesheets/features/sync/data/database/database.drift.dart'
    as i2;
import 'package:timesheets/features/timer/data/models/timer_status.dart' as i3;
import 'package:timesheets/features/sync/data/database/database.dart' as i4;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i5;
import 'package:drift/internal/modular.dart' as i6;

typedef $$AnalyticLinesTableCreateCompanionBuilder = i2.AnalyticLinesCompanion
    Function({
  required int id,
  required DateTime createDate,
  required DateTime writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  required String backendId,
  required DateTime date,
  required String name,
  required int projectId,
  required int taskId,
  i0.Value<double?> unitAmount,
  i0.Value<i3.TimerStatus> currentStatus,
  i0.Value<DateTime?> lastTicked,
  i0.Value<bool> isFavorite,
  i0.Value<DateTime?> startTime,
  i0.Value<DateTime?> endTime,
  i0.Value<String?> showTimeControl,
  i0.Value<int> rowid,
});
typedef $$AnalyticLinesTableUpdateCompanionBuilder = i2.AnalyticLinesCompanion
    Function({
  i0.Value<int> id,
  i0.Value<DateTime> createDate,
  i0.Value<DateTime> writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  i0.Value<String> backendId,
  i0.Value<DateTime> date,
  i0.Value<String> name,
  i0.Value<int> projectId,
  i0.Value<int> taskId,
  i0.Value<double?> unitAmount,
  i0.Value<i3.TimerStatus> currentStatus,
  i0.Value<DateTime?> lastTicked,
  i0.Value<bool> isFavorite,
  i0.Value<DateTime?> startTime,
  i0.Value<DateTime?> endTime,
  i0.Value<String?> showTimeControl,
  i0.Value<int> rowid,
});

class $$AnalyticLinesTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$AnalyticLinesTable> {
  $$AnalyticLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get writeDate => $composableBuilder(
      column: $table.writeDate, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<bool> get isMarkedAsDeleted => $composableBuilder(
      column: $table.isMarkedAsDeleted,
      builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<double> get unitAmount => $composableBuilder(
      column: $table.unitAmount, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnWithTypeConverterFilters<i3.TimerStatus, i3.TimerStatus, int>
      get currentStatus => $composableBuilder(
          column: $table.currentStatus,
          builder: (column) => i0.ColumnWithTypeConverterFilters(column));

  i0.ColumnFilters<DateTime> get lastTicked => $composableBuilder(
      column: $table.lastTicked, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<String> get showTimeControl => $composableBuilder(
      column: $table.showTimeControl,
      builder: (column) => i0.ColumnFilters(column));

  i1.$$SyncBackendsTableFilterComposer get backendId {
    final i1.$$SyncBackendsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.backendId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i1.$SyncBackendsTable>('sync_backends'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i1.$$SyncBackendsTableFilterComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i1.$SyncBackendsTable>('sync_backends'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i2.$$ProjectProjectsTableFilterComposer get projectId {
    final i2.$$ProjectProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$ProjectProjectsTable>('project_projects'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$ProjectProjectsTableFilterComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$ProjectProjectsTable>('project_projects'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i2.$$ProjectTasksTableFilterComposer get taskId {
    final i2.$$ProjectTasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$ProjectTasksTable>('project_tasks'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$ProjectTasksTableFilterComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$ProjectTasksTable>('project_tasks'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AnalyticLinesTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$AnalyticLinesTable> {
  $$AnalyticLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get createDate => $composableBuilder(
      column: $table.createDate,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get writeDate => $composableBuilder(
      column: $table.writeDate,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<bool> get isMarkedAsDeleted => $composableBuilder(
      column: $table.isMarkedAsDeleted,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<double> get unitAmount => $composableBuilder(
      column: $table.unitAmount,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<int> get currentStatus => $composableBuilder(
      column: $table.currentStatus,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get lastTicked => $composableBuilder(
      column: $table.lastTicked,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<String> get showTimeControl => $composableBuilder(
      column: $table.showTimeControl,
      builder: (column) => i0.ColumnOrderings(column));

  i1.$$SyncBackendsTableOrderingComposer get backendId {
    final i1.$$SyncBackendsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.backendId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i1.$SyncBackendsTable>('sync_backends'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i1.$$SyncBackendsTableOrderingComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i1.$SyncBackendsTable>('sync_backends'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i2.$$ProjectProjectsTableOrderingComposer get projectId {
    final i2.$$ProjectProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$ProjectProjectsTable>('project_projects'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$ProjectProjectsTableOrderingComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$ProjectProjectsTable>('project_projects'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i2.$$ProjectTasksTableOrderingComposer get taskId {
    final i2.$$ProjectTasksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$ProjectTasksTable>('project_tasks'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$ProjectTasksTableOrderingComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$ProjectTasksTable>('project_tasks'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AnalyticLinesTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$AnalyticLinesTable> {
  $$AnalyticLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get writeDate =>
      $composableBuilder(column: $table.writeDate, builder: (column) => column);

  i0.GeneratedColumn<bool> get isMarkedAsDeleted => $composableBuilder(
      column: $table.isMarkedAsDeleted, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  i0.GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  i0.GeneratedColumn<double> get unitAmount => $composableBuilder(
      column: $table.unitAmount, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i3.TimerStatus, int> get currentStatus =>
      $composableBuilder(
          column: $table.currentStatus, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get lastTicked => $composableBuilder(
      column: $table.lastTicked, builder: (column) => column);

  i0.GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  i0.GeneratedColumn<String> get showTimeControl => $composableBuilder(
      column: $table.showTimeControl, builder: (column) => column);

  i1.$$SyncBackendsTableAnnotationComposer get backendId {
    final i1.$$SyncBackendsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.backendId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i1.$SyncBackendsTable>('sync_backends'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i1.$$SyncBackendsTableAnnotationComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i1.$SyncBackendsTable>('sync_backends'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i2.$$ProjectProjectsTableAnnotationComposer get projectId {
    final i2.$$ProjectProjectsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.projectId,
            referencedTable: i6.ReadDatabaseContainer($db)
                .resultSet<i2.$ProjectProjectsTable>('project_projects'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                i2.$$ProjectProjectsTableAnnotationComposer(
                  $db: $db,
                  $table: i6.ReadDatabaseContainer($db)
                      .resultSet<i2.$ProjectProjectsTable>('project_projects'),
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  i2.$$ProjectTasksTableAnnotationComposer get taskId {
    final i2.$$ProjectTasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$ProjectTasksTable>('project_tasks'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$ProjectTasksTableAnnotationComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$ProjectTasksTable>('project_tasks'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AnalyticLinesTableTableManager extends i0.RootTableManager<
    i0.GeneratedDatabase,
    i2.$AnalyticLinesTable,
    i2.AnalyticLine,
    i2.$$AnalyticLinesTableFilterComposer,
    i2.$$AnalyticLinesTableOrderingComposer,
    i2.$$AnalyticLinesTableAnnotationComposer,
    $$AnalyticLinesTableCreateCompanionBuilder,
    $$AnalyticLinesTableUpdateCompanionBuilder,
    (
      i2.AnalyticLine,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$AnalyticLinesTable,
          i2.AnalyticLine>
    ),
    i2.AnalyticLine,
    i0.PrefetchHooks Function({bool backendId, bool projectId, bool taskId})> {
  $$AnalyticLinesTableTableManager(
      i0.GeneratedDatabase db, i2.$AnalyticLinesTable table)
      : super(i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i2.$$AnalyticLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i2.$$AnalyticLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i2.$$AnalyticLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            i0.Value<int> id = const i0.Value.absent(),
            i0.Value<DateTime> createDate = const i0.Value.absent(),
            i0.Value<DateTime> writeDate = const i0.Value.absent(),
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            i0.Value<String> backendId = const i0.Value.absent(),
            i0.Value<DateTime> date = const i0.Value.absent(),
            i0.Value<String> name = const i0.Value.absent(),
            i0.Value<int> projectId = const i0.Value.absent(),
            i0.Value<int> taskId = const i0.Value.absent(),
            i0.Value<double?> unitAmount = const i0.Value.absent(),
            i0.Value<i3.TimerStatus> currentStatus = const i0.Value.absent(),
            i0.Value<DateTime?> lastTicked = const i0.Value.absent(),
            i0.Value<bool> isFavorite = const i0.Value.absent(),
            i0.Value<DateTime?> startTime = const i0.Value.absent(),
            i0.Value<DateTime?> endTime = const i0.Value.absent(),
            i0.Value<String?> showTimeControl = const i0.Value.absent(),
            i0.Value<int> rowid = const i0.Value.absent(),
          }) =>
              i2.AnalyticLinesCompanion(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            date: date,
            name: name,
            projectId: projectId,
            taskId: taskId,
            unitAmount: unitAmount,
            currentStatus: currentStatus,
            lastTicked: lastTicked,
            isFavorite: isFavorite,
            startTime: startTime,
            endTime: endTime,
            showTimeControl: showTimeControl,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required DateTime createDate,
            required DateTime writeDate,
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            required String backendId,
            required DateTime date,
            required String name,
            required int projectId,
            required int taskId,
            i0.Value<double?> unitAmount = const i0.Value.absent(),
            i0.Value<i3.TimerStatus> currentStatus = const i0.Value.absent(),
            i0.Value<DateTime?> lastTicked = const i0.Value.absent(),
            i0.Value<bool> isFavorite = const i0.Value.absent(),
            i0.Value<DateTime?> startTime = const i0.Value.absent(),
            i0.Value<DateTime?> endTime = const i0.Value.absent(),
            i0.Value<String?> showTimeControl = const i0.Value.absent(),
            i0.Value<int> rowid = const i0.Value.absent(),
          }) =>
              i2.AnalyticLinesCompanion.insert(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            date: date,
            name: name,
            projectId: projectId,
            taskId: taskId,
            unitAmount: unitAmount,
            currentStatus: currentStatus,
            lastTicked: lastTicked,
            isFavorite: isFavorite,
            startTime: startTime,
            endTime: endTime,
            showTimeControl: showTimeControl,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AnalyticLinesTableProcessedTableManager = i0.ProcessedTableManager<
    i0.GeneratedDatabase,
    i2.$AnalyticLinesTable,
    i2.AnalyticLine,
    i2.$$AnalyticLinesTableFilterComposer,
    i2.$$AnalyticLinesTableOrderingComposer,
    i2.$$AnalyticLinesTableAnnotationComposer,
    $$AnalyticLinesTableCreateCompanionBuilder,
    $$AnalyticLinesTableUpdateCompanionBuilder,
    (
      i2.AnalyticLine,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$AnalyticLinesTable,
          i2.AnalyticLine>
    ),
    i2.AnalyticLine,
    i0.PrefetchHooks Function({bool backendId, bool projectId, bool taskId})>;
typedef $$ProjectProjectsTableCreateCompanionBuilder
    = i2.ProjectProjectsCompanion Function({
  required int id,
  required DateTime createDate,
  required DateTime writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  required String backendId,
  i0.Value<bool> active,
  i0.Value<bool> isFavorite,
  i0.Value<int?> color,
  required String name,
  i0.Value<int> taskCount,
  i0.Value<int> rowid,
});
typedef $$ProjectProjectsTableUpdateCompanionBuilder
    = i2.ProjectProjectsCompanion Function({
  i0.Value<int> id,
  i0.Value<DateTime> createDate,
  i0.Value<DateTime> writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  i0.Value<String> backendId,
  i0.Value<bool> active,
  i0.Value<bool> isFavorite,
  i0.Value<int?> color,
  i0.Value<String> name,
  i0.Value<int> taskCount,
  i0.Value<int> rowid,
});

class $$ProjectProjectsTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$ProjectProjectsTable> {
  $$ProjectProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get writeDate => $composableBuilder(
      column: $table.writeDate, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<bool> get isMarkedAsDeleted => $composableBuilder(
      column: $table.isMarkedAsDeleted,
      builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<int> get taskCount => $composableBuilder(
      column: $table.taskCount, builder: (column) => i0.ColumnFilters(column));

  i1.$$SyncBackendsTableFilterComposer get backendId {
    final i1.$$SyncBackendsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.backendId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i1.$SyncBackendsTable>('sync_backends'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i1.$$SyncBackendsTableFilterComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i1.$SyncBackendsTable>('sync_backends'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i0.Expression<bool> analyticLinesRefs(
      i0.Expression<bool> Function(i2.$$AnalyticLinesTableFilterComposer f) f) {
    final i2.$$AnalyticLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$AnalyticLinesTable>('analytic_lines'),
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$AnalyticLinesTableFilterComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$AnalyticLinesTable>('analytic_lines'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  i0.Expression<bool> projectTasksRefs(
      i0.Expression<bool> Function(i2.$$ProjectTasksTableFilterComposer f) f) {
    final i2.$$ProjectTasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$ProjectTasksTable>('project_tasks'),
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$ProjectTasksTableFilterComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$ProjectTasksTable>('project_tasks'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectProjectsTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$ProjectProjectsTable> {
  $$ProjectProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get createDate => $composableBuilder(
      column: $table.createDate,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get writeDate => $composableBuilder(
      column: $table.writeDate,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<bool> get isMarkedAsDeleted => $composableBuilder(
      column: $table.isMarkedAsDeleted,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<int> get taskCount => $composableBuilder(
      column: $table.taskCount,
      builder: (column) => i0.ColumnOrderings(column));

  i1.$$SyncBackendsTableOrderingComposer get backendId {
    final i1.$$SyncBackendsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.backendId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i1.$SyncBackendsTable>('sync_backends'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i1.$$SyncBackendsTableOrderingComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i1.$SyncBackendsTable>('sync_backends'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProjectProjectsTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$ProjectProjectsTable> {
  $$ProjectProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get writeDate =>
      $composableBuilder(column: $table.writeDate, builder: (column) => column);

  i0.GeneratedColumn<bool> get isMarkedAsDeleted => $composableBuilder(
      column: $table.isMarkedAsDeleted, builder: (column) => column);

  i0.GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  i0.GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  i0.GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  i0.GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  i0.GeneratedColumn<int> get taskCount =>
      $composableBuilder(column: $table.taskCount, builder: (column) => column);

  i1.$$SyncBackendsTableAnnotationComposer get backendId {
    final i1.$$SyncBackendsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.backendId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i1.$SyncBackendsTable>('sync_backends'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i1.$$SyncBackendsTableAnnotationComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i1.$SyncBackendsTable>('sync_backends'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i0.Expression<T> analyticLinesRefs<T extends Object>(
      i0.Expression<T> Function(i2.$$AnalyticLinesTableAnnotationComposer a)
          f) {
    final i2.$$AnalyticLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$AnalyticLinesTable>('analytic_lines'),
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$AnalyticLinesTableAnnotationComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$AnalyticLinesTable>('analytic_lines'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  i0.Expression<T> projectTasksRefs<T extends Object>(
      i0.Expression<T> Function(i2.$$ProjectTasksTableAnnotationComposer a) f) {
    final i2.$$ProjectTasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$ProjectTasksTable>('project_tasks'),
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$ProjectTasksTableAnnotationComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$ProjectTasksTable>('project_tasks'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectProjectsTableTableManager extends i0.RootTableManager<
    i0.GeneratedDatabase,
    i2.$ProjectProjectsTable,
    i2.ProjectProject,
    i2.$$ProjectProjectsTableFilterComposer,
    i2.$$ProjectProjectsTableOrderingComposer,
    i2.$$ProjectProjectsTableAnnotationComposer,
    $$ProjectProjectsTableCreateCompanionBuilder,
    $$ProjectProjectsTableUpdateCompanionBuilder,
    (
      i2.ProjectProject,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$ProjectProjectsTable,
          i2.ProjectProject>
    ),
    i2.ProjectProject,
    i0.PrefetchHooks Function(
        {bool backendId, bool analyticLinesRefs, bool projectTasksRefs})> {
  $$ProjectProjectsTableTableManager(
      i0.GeneratedDatabase db, i2.$ProjectProjectsTable table)
      : super(i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i2.$$ProjectProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i2.$$ProjectProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => i2
              .$$ProjectProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            i0.Value<int> id = const i0.Value.absent(),
            i0.Value<DateTime> createDate = const i0.Value.absent(),
            i0.Value<DateTime> writeDate = const i0.Value.absent(),
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            i0.Value<String> backendId = const i0.Value.absent(),
            i0.Value<bool> active = const i0.Value.absent(),
            i0.Value<bool> isFavorite = const i0.Value.absent(),
            i0.Value<int?> color = const i0.Value.absent(),
            i0.Value<String> name = const i0.Value.absent(),
            i0.Value<int> taskCount = const i0.Value.absent(),
            i0.Value<int> rowid = const i0.Value.absent(),
          }) =>
              i2.ProjectProjectsCompanion(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            active: active,
            isFavorite: isFavorite,
            color: color,
            name: name,
            taskCount: taskCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required DateTime createDate,
            required DateTime writeDate,
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            required String backendId,
            i0.Value<bool> active = const i0.Value.absent(),
            i0.Value<bool> isFavorite = const i0.Value.absent(),
            i0.Value<int?> color = const i0.Value.absent(),
            required String name,
            i0.Value<int> taskCount = const i0.Value.absent(),
            i0.Value<int> rowid = const i0.Value.absent(),
          }) =>
              i2.ProjectProjectsCompanion.insert(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            active: active,
            isFavorite: isFavorite,
            color: color,
            name: name,
            taskCount: taskCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProjectProjectsTableProcessedTableManager = i0.ProcessedTableManager<
    i0.GeneratedDatabase,
    i2.$ProjectProjectsTable,
    i2.ProjectProject,
    i2.$$ProjectProjectsTableFilterComposer,
    i2.$$ProjectProjectsTableOrderingComposer,
    i2.$$ProjectProjectsTableAnnotationComposer,
    $$ProjectProjectsTableCreateCompanionBuilder,
    $$ProjectProjectsTableUpdateCompanionBuilder,
    (
      i2.ProjectProject,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$ProjectProjectsTable,
          i2.ProjectProject>
    ),
    i2.ProjectProject,
    i0.PrefetchHooks Function(
        {bool backendId, bool analyticLinesRefs, bool projectTasksRefs})>;
typedef $$ProjectTasksTableCreateCompanionBuilder = i2.ProjectTasksCompanion
    Function({
  required int id,
  required DateTime createDate,
  required DateTime writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  required String backendId,
  i0.Value<bool> active,
  i0.Value<int?> color,
  i0.Value<DateTime?> dateDeadline,
  i0.Value<DateTime?> dateEnd,
  i0.Value<String?> description,
  required String name,
  i0.Value<String?> priority,
  required int projectId,
  i0.Value<int> rowid,
});
typedef $$ProjectTasksTableUpdateCompanionBuilder = i2.ProjectTasksCompanion
    Function({
  i0.Value<int> id,
  i0.Value<DateTime> createDate,
  i0.Value<DateTime> writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  i0.Value<String> backendId,
  i0.Value<bool> active,
  i0.Value<int?> color,
  i0.Value<DateTime?> dateDeadline,
  i0.Value<DateTime?> dateEnd,
  i0.Value<String?> description,
  i0.Value<String> name,
  i0.Value<String?> priority,
  i0.Value<int> projectId,
  i0.Value<int> rowid,
});

class $$ProjectTasksTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$ProjectTasksTable> {
  $$ProjectTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get writeDate => $composableBuilder(
      column: $table.writeDate, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<bool> get isMarkedAsDeleted => $composableBuilder(
      column: $table.isMarkedAsDeleted,
      builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get dateDeadline => $composableBuilder(
      column: $table.dateDeadline,
      builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<DateTime> get dateEnd => $composableBuilder(
      column: $table.dateEnd, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<String> get description => $composableBuilder(
      column: $table.description,
      builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => i0.ColumnFilters(column));

  i0.ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => i0.ColumnFilters(column));

  i1.$$SyncBackendsTableFilterComposer get backendId {
    final i1.$$SyncBackendsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.backendId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i1.$SyncBackendsTable>('sync_backends'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i1.$$SyncBackendsTableFilterComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i1.$SyncBackendsTable>('sync_backends'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i2.$$ProjectProjectsTableFilterComposer get projectId {
    final i2.$$ProjectProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$ProjectProjectsTable>('project_projects'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$ProjectProjectsTableFilterComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$ProjectProjectsTable>('project_projects'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i0.Expression<bool> analyticLinesRefs(
      i0.Expression<bool> Function(i2.$$AnalyticLinesTableFilterComposer f) f) {
    final i2.$$AnalyticLinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$AnalyticLinesTable>('analytic_lines'),
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$AnalyticLinesTableFilterComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$AnalyticLinesTable>('analytic_lines'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectTasksTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$ProjectTasksTable> {
  $$ProjectTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get createDate => $composableBuilder(
      column: $table.createDate,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get writeDate => $composableBuilder(
      column: $table.writeDate,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<bool> get isMarkedAsDeleted => $composableBuilder(
      column: $table.isMarkedAsDeleted,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get dateDeadline => $composableBuilder(
      column: $table.dateDeadline,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<DateTime> get dateEnd => $composableBuilder(
      column: $table.dateEnd, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description,
      builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => i0.ColumnOrderings(column));

  i0.ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => i0.ColumnOrderings(column));

  i1.$$SyncBackendsTableOrderingComposer get backendId {
    final i1.$$SyncBackendsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.backendId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i1.$SyncBackendsTable>('sync_backends'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i1.$$SyncBackendsTableOrderingComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i1.$SyncBackendsTable>('sync_backends'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i2.$$ProjectProjectsTableOrderingComposer get projectId {
    final i2.$$ProjectProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$ProjectProjectsTable>('project_projects'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$ProjectProjectsTableOrderingComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$ProjectProjectsTable>('project_projects'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProjectTasksTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$ProjectTasksTable> {
  $$ProjectTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get createDate => $composableBuilder(
      column: $table.createDate, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get writeDate =>
      $composableBuilder(column: $table.writeDate, builder: (column) => column);

  i0.GeneratedColumn<bool> get isMarkedAsDeleted => $composableBuilder(
      column: $table.isMarkedAsDeleted, builder: (column) => column);

  i0.GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  i0.GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get dateDeadline => $composableBuilder(
      column: $table.dateDeadline, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get dateEnd =>
      $composableBuilder(column: $table.dateEnd, builder: (column) => column);

  i0.GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  i0.GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  i0.GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  i1.$$SyncBackendsTableAnnotationComposer get backendId {
    final i1.$$SyncBackendsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.backendId,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i1.$SyncBackendsTable>('sync_backends'),
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i1.$$SyncBackendsTableAnnotationComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i1.$SyncBackendsTable>('sync_backends'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  i2.$$ProjectProjectsTableAnnotationComposer get projectId {
    final i2.$$ProjectProjectsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.projectId,
            referencedTable: i6.ReadDatabaseContainer($db)
                .resultSet<i2.$ProjectProjectsTable>('project_projects'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                i2.$$ProjectProjectsTableAnnotationComposer(
                  $db: $db,
                  $table: i6.ReadDatabaseContainer($db)
                      .resultSet<i2.$ProjectProjectsTable>('project_projects'),
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  i0.Expression<T> analyticLinesRefs<T extends Object>(
      i0.Expression<T> Function(i2.$$AnalyticLinesTableAnnotationComposer a)
          f) {
    final i2.$$AnalyticLinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: i6.ReadDatabaseContainer($db)
            .resultSet<i2.$AnalyticLinesTable>('analytic_lines'),
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            i2.$$AnalyticLinesTableAnnotationComposer(
              $db: $db,
              $table: i6.ReadDatabaseContainer($db)
                  .resultSet<i2.$AnalyticLinesTable>('analytic_lines'),
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectTasksTableTableManager extends i0.RootTableManager<
    i0.GeneratedDatabase,
    i2.$ProjectTasksTable,
    i2.ProjectTask,
    i2.$$ProjectTasksTableFilterComposer,
    i2.$$ProjectTasksTableOrderingComposer,
    i2.$$ProjectTasksTableAnnotationComposer,
    $$ProjectTasksTableCreateCompanionBuilder,
    $$ProjectTasksTableUpdateCompanionBuilder,
    (
      i2.ProjectTask,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$ProjectTasksTable,
          i2.ProjectTask>
    ),
    i2.ProjectTask,
    i0.PrefetchHooks Function(
        {bool backendId, bool projectId, bool analyticLinesRefs})> {
  $$ProjectTasksTableTableManager(
      i0.GeneratedDatabase db, i2.$ProjectTasksTable table)
      : super(i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i2.$$ProjectTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i2.$$ProjectTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i2.$$ProjectTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            i0.Value<int> id = const i0.Value.absent(),
            i0.Value<DateTime> createDate = const i0.Value.absent(),
            i0.Value<DateTime> writeDate = const i0.Value.absent(),
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            i0.Value<String> backendId = const i0.Value.absent(),
            i0.Value<bool> active = const i0.Value.absent(),
            i0.Value<int?> color = const i0.Value.absent(),
            i0.Value<DateTime?> dateDeadline = const i0.Value.absent(),
            i0.Value<DateTime?> dateEnd = const i0.Value.absent(),
            i0.Value<String?> description = const i0.Value.absent(),
            i0.Value<String> name = const i0.Value.absent(),
            i0.Value<String?> priority = const i0.Value.absent(),
            i0.Value<int> projectId = const i0.Value.absent(),
            i0.Value<int> rowid = const i0.Value.absent(),
          }) =>
              i2.ProjectTasksCompanion(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            active: active,
            color: color,
            dateDeadline: dateDeadline,
            dateEnd: dateEnd,
            description: description,
            name: name,
            priority: priority,
            projectId: projectId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required DateTime createDate,
            required DateTime writeDate,
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            required String backendId,
            i0.Value<bool> active = const i0.Value.absent(),
            i0.Value<int?> color = const i0.Value.absent(),
            i0.Value<DateTime?> dateDeadline = const i0.Value.absent(),
            i0.Value<DateTime?> dateEnd = const i0.Value.absent(),
            i0.Value<String?> description = const i0.Value.absent(),
            required String name,
            i0.Value<String?> priority = const i0.Value.absent(),
            required int projectId,
            i0.Value<int> rowid = const i0.Value.absent(),
          }) =>
              i2.ProjectTasksCompanion.insert(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            active: active,
            color: color,
            dateDeadline: dateDeadline,
            dateEnd: dateEnd,
            description: description,
            name: name,
            priority: priority,
            projectId: projectId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProjectTasksTableProcessedTableManager = i0.ProcessedTableManager<
    i0.GeneratedDatabase,
    i2.$ProjectTasksTable,
    i2.ProjectTask,
    i2.$$ProjectTasksTableFilterComposer,
    i2.$$ProjectTasksTableOrderingComposer,
    i2.$$ProjectTasksTableAnnotationComposer,
    $$ProjectTasksTableCreateCompanionBuilder,
    $$ProjectTasksTableUpdateCompanionBuilder,
    (
      i2.ProjectTask,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$ProjectTasksTable,
          i2.ProjectTask>
    ),
    i2.ProjectTask,
    i0.PrefetchHooks Function(
        {bool backendId, bool projectId, bool analyticLinesRefs})>;

abstract class $AppDatabase extends i0.GeneratedDatabase {
  $AppDatabase(i0.QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final i1.$SyncBackendsTable syncBackends = i1.$SyncBackendsTable(this);
  late final i2.$ProjectProjectsTable projectProjects =
      i2.$ProjectProjectsTable(this);
  late final i2.$ProjectTasksTable projectTasks = i2.$ProjectTasksTable(this);
  late final i2.$AnalyticLinesTable analyticLines =
      i2.$AnalyticLinesTable(this);
  late final i1.$SyncRegistriesTable syncRegistries =
      i1.$SyncRegistriesTable(this);
  @override
  Iterable<i0.TableInfo<i0.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<i0.TableInfo<i0.Table, Object?>>();
  @override
  List<i0.DatabaseSchemaEntity> get allSchemaEntities => [
        syncBackends,
        projectProjects,
        projectTasks,
        analyticLines,
        syncRegistries,
        i2.analyticLinesProjectTask,
        i2.analyticLinesStatus,
        i2.analyticLinesFavorite,
        i2.projectProjectsName,
        i2.projectProjectsFavorite,
        i2.projectTasksProject,
        i2.projectTasksName
      ];
  @override
  i0.StreamQueryUpdateRules get streamUpdateRules =>
      const i0.StreamQueryUpdateRules(
        [
          i0.WritePropagation(
            on: i0.TableUpdateQuery.onTableName('sync_backends',
                limitUpdateKind: i0.UpdateKind.delete),
            result: [
              i0.TableUpdate('sync_registries', kind: i0.UpdateKind.delete),
            ],
          ),
        ],
      );
  @override
  i0.DriftDatabaseOptions get options =>
      const i0.DriftDatabaseOptions(storeDateTimeAsText: true);
}

class $AppDatabaseManager {
  final $AppDatabase _db;
  $AppDatabaseManager(this._db);
  i1.$$SyncBackendsTableTableManager get syncBackends =>
      i1.$$SyncBackendsTableTableManager(_db, _db.syncBackends);
  i2.$$ProjectProjectsTableTableManager get projectProjects =>
      i2.$$ProjectProjectsTableTableManager(_db, _db.projectProjects);
  i2.$$ProjectTasksTableTableManager get projectTasks =>
      i2.$$ProjectTasksTableTableManager(_db, _db.projectTasks);
  i2.$$AnalyticLinesTableTableManager get analyticLines =>
      i2.$$AnalyticLinesTableTableManager(_db, _db.analyticLines);
  i1.$$SyncRegistriesTableTableManager get syncRegistries =>
      i1.$$SyncRegistriesTableTableManager(_db, _db.syncRegistries);
}

class $AnalyticLinesTable extends i4.AnalyticLines
    with i0.TableInfo<$AnalyticLinesTable, i2.AnalyticLine> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalyticLinesTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _createDateMeta =
      const i0.VerificationMeta('createDate');
  @override
  late final i0.GeneratedColumn<DateTime> createDate =
      i0.GeneratedColumn<DateTime>('create_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _writeDateMeta =
      const i0.VerificationMeta('writeDate');
  @override
  late final i0.GeneratedColumn<DateTime> writeDate =
      i0.GeneratedColumn<DateTime>('write_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _isMarkedAsDeletedMeta =
      const i0.VerificationMeta('isMarkedAsDeleted');
  @override
  late final i0.GeneratedColumn<bool> isMarkedAsDeleted =
      i0.GeneratedColumn<bool>('is_marked_as_deleted', aliasedName, false,
          type: i0.DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'CHECK ("is_marked_as_deleted" IN (0, 1))'),
          defaultValue: const i5.Constant(false));
  static const i0.VerificationMeta _backendIdMeta =
      const i0.VerificationMeta('backendId');
  @override
  late final i0.GeneratedColumn<String> backendId = i0.GeneratedColumn<String>(
      'backend_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_backends (id)'));
  static const i0.VerificationMeta _dateMeta =
      const i0.VerificationMeta('date');
  @override
  late final i0.GeneratedColumn<DateTime> date = i0.GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _nameMeta =
      const i0.VerificationMeta('name');
  @override
  late final i0.GeneratedColumn<String> name = i0.GeneratedColumn<String>(
      'name', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _projectIdMeta =
      const i0.VerificationMeta('projectId');
  @override
  late final i0.GeneratedColumn<int> projectId = i0.GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES project_projects (id) ON DELETE RESTRICT'));
  static const i0.VerificationMeta _taskIdMeta =
      const i0.VerificationMeta('taskId');
  @override
  late final i0.GeneratedColumn<int> taskId = i0.GeneratedColumn<int>(
      'task_id', aliasedName, false,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES project_tasks (id) ON DELETE RESTRICT'));
  static const i0.VerificationMeta _unitAmountMeta =
      const i0.VerificationMeta('unitAmount');
  @override
  late final i0.GeneratedColumn<double> unitAmount = i0.GeneratedColumn<double>(
      'unit_amount', aliasedName, true,
      type: i0.DriftSqlType.double, requiredDuringInsert: false);
  static const i0.VerificationMeta _currentStatusMeta =
      const i0.VerificationMeta('currentStatus');
  @override
  late final i0.GeneratedColumnWithTypeConverter<i3.TimerStatus, int>
      currentStatus = i0.GeneratedColumn<int>(
              'current_status', aliasedName, false,
              type: i0.DriftSqlType.int,
              requiredDuringInsert: false,
              clientDefault: () => i3.TimerStatus.initial.index)
          .withConverter<i3.TimerStatus>(
              i2.$AnalyticLinesTable.$convertercurrentStatus);
  static const i0.VerificationMeta _lastTickedMeta =
      const i0.VerificationMeta('lastTicked');
  @override
  late final i0.GeneratedColumn<DateTime> lastTicked =
      i0.GeneratedColumn<DateTime>('last_ticked', aliasedName, true,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: false);
  static const i0.VerificationMeta _isFavoriteMeta =
      const i0.VerificationMeta('isFavorite');
  @override
  late final i0.GeneratedColumn<bool> isFavorite = i0.GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: i0.DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const i5.Constant(false));
  static const i0.VerificationMeta _startTimeMeta =
      const i0.VerificationMeta('startTime');
  @override
  late final i0.GeneratedColumn<DateTime> startTime =
      i0.GeneratedColumn<DateTime>('start_time', aliasedName, true,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: false);
  static const i0.VerificationMeta _endTimeMeta =
      const i0.VerificationMeta('endTime');
  @override
  late final i0.GeneratedColumn<DateTime> endTime =
      i0.GeneratedColumn<DateTime>('end_time', aliasedName, true,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: false);
  static const i0.VerificationMeta _showTimeControlMeta =
      const i0.VerificationMeta('showTimeControl');
  @override
  late final i0.GeneratedColumn<String> showTimeControl =
      i0.GeneratedColumn<String>('show_time_control', aliasedName, true,
          type: i0.DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        createDate,
        writeDate,
        isMarkedAsDeleted,
        backendId,
        date,
        name,
        projectId,
        taskId,
        unitAmount,
        currentStatus,
        lastTicked,
        isFavorite,
        startTime,
        endTime,
        showTimeControl
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analytic_lines';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i2.AnalyticLine> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    } else if (isInserting) {
      context.missing(_createDateMeta);
    }
    if (data.containsKey('write_date')) {
      context.handle(_writeDateMeta,
          writeDate.isAcceptableOrUnknown(data['write_date']!, _writeDateMeta));
    } else if (isInserting) {
      context.missing(_writeDateMeta);
    }
    if (data.containsKey('is_marked_as_deleted')) {
      context.handle(
          _isMarkedAsDeletedMeta,
          isMarkedAsDeleted.isAcceptableOrUnknown(
              data['is_marked_as_deleted']!, _isMarkedAsDeletedMeta));
    }
    if (data.containsKey('backend_id')) {
      context.handle(_backendIdMeta,
          backendId.isAcceptableOrUnknown(data['backend_id']!, _backendIdMeta));
    } else if (isInserting) {
      context.missing(_backendIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('unit_amount')) {
      context.handle(
          _unitAmountMeta,
          unitAmount.isAcceptableOrUnknown(
              data['unit_amount']!, _unitAmountMeta));
    }
    context.handle(_currentStatusMeta, const i0.VerificationResult.success());
    if (data.containsKey('last_ticked')) {
      context.handle(
          _lastTickedMeta,
          lastTicked.isAcceptableOrUnknown(
              data['last_ticked']!, _lastTickedMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('show_time_control')) {
      context.handle(
          _showTimeControlMeta,
          showTimeControl.isAcceptableOrUnknown(
              data['show_time_control']!, _showTimeControlMeta));
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {backendId, id};
  @override
  i2.AnalyticLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i2.AnalyticLine(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}id'])!,
      createDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}create_date'])!,
      writeDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}write_date'])!,
      isMarkedAsDeleted: attachedDatabase.typeMapping.read(i0.DriftSqlType.bool,
          data['${effectivePrefix}is_marked_as_deleted'])!,
      backendId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}backend_id'])!,
      date: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      name: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}name'])!,
      projectId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}project_id'])!,
      taskId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}task_id'])!,
      unitAmount: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.double, data['${effectivePrefix}unit_amount']),
      currentStatus: i2.$AnalyticLinesTable.$convertercurrentStatus.fromSql(
          attachedDatabase.typeMapping.read(
              i0.DriftSqlType.int, data['${effectivePrefix}current_status'])!),
      lastTicked: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}last_ticked']),
      isFavorite: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      startTime: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}start_time']),
      endTime: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      showTimeControl: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string, data['${effectivePrefix}show_time_control']),
    );
  }

  @override
  $AnalyticLinesTable createAlias(String alias) {
    return $AnalyticLinesTable(attachedDatabase, alias);
  }

  static i0.JsonTypeConverter2<i3.TimerStatus, int, int>
      $convertercurrentStatus =
      const i0.EnumIndexConverter<i3.TimerStatus>(i3.TimerStatus.values);
}

class AnalyticLine extends i0.DataClass
    implements i0.Insertable<i2.AnalyticLine> {
  final int id;
  final DateTime createDate;
  final DateTime writeDate;
  final bool isMarkedAsDeleted;
  final String backendId;
  final DateTime date;
  final String name;
  final int projectId;
  final int taskId;
  final double? unitAmount;
  final i3.TimerStatus currentStatus;
  final DateTime? lastTicked;
  final bool isFavorite;

  /// could not use odoo fields directly as dateTime is reserved by drift fields
  final DateTime? startTime;
  final DateTime? endTime;
  final String? showTimeControl;
  const AnalyticLine(
      {required this.id,
      required this.createDate,
      required this.writeDate,
      required this.isMarkedAsDeleted,
      required this.backendId,
      required this.date,
      required this.name,
      required this.projectId,
      required this.taskId,
      this.unitAmount,
      required this.currentStatus,
      this.lastTicked,
      required this.isFavorite,
      this.startTime,
      this.endTime,
      this.showTimeControl});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['create_date'] = i0.Variable<DateTime>(createDate);
    map['write_date'] = i0.Variable<DateTime>(writeDate);
    map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted);
    map['backend_id'] = i0.Variable<String>(backendId);
    map['date'] = i0.Variable<DateTime>(date);
    map['name'] = i0.Variable<String>(name);
    map['project_id'] = i0.Variable<int>(projectId);
    map['task_id'] = i0.Variable<int>(taskId);
    if (!nullToAbsent || unitAmount != null) {
      map['unit_amount'] = i0.Variable<double>(unitAmount);
    }
    {
      map['current_status'] = i0.Variable<int>(
          i2.$AnalyticLinesTable.$convertercurrentStatus.toSql(currentStatus));
    }
    if (!nullToAbsent || lastTicked != null) {
      map['last_ticked'] = i0.Variable<DateTime>(lastTicked);
    }
    map['is_favorite'] = i0.Variable<bool>(isFavorite);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = i0.Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = i0.Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || showTimeControl != null) {
      map['show_time_control'] = i0.Variable<String>(showTimeControl);
    }
    return map;
  }

  i2.AnalyticLinesCompanion toCompanion(bool nullToAbsent) {
    return i2.AnalyticLinesCompanion(
      id: i0.Value(id),
      createDate: i0.Value(createDate),
      writeDate: i0.Value(writeDate),
      isMarkedAsDeleted: i0.Value(isMarkedAsDeleted),
      backendId: i0.Value(backendId),
      date: i0.Value(date),
      name: i0.Value(name),
      projectId: i0.Value(projectId),
      taskId: i0.Value(taskId),
      unitAmount: unitAmount == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(unitAmount),
      currentStatus: i0.Value(currentStatus),
      lastTicked: lastTicked == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(lastTicked),
      isFavorite: i0.Value(isFavorite),
      startTime: startTime == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(endTime),
      showTimeControl: showTimeControl == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(showTimeControl),
    );
  }

  factory AnalyticLine.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return AnalyticLine(
      id: serializer.fromJson<int>(json['id']),
      createDate: serializer.fromJson<DateTime>(json['createDate']),
      writeDate: serializer.fromJson<DateTime>(json['writeDate']),
      isMarkedAsDeleted: serializer.fromJson<bool>(json['isMarkedAsDeleted']),
      backendId: serializer.fromJson<String>(json['backendId']),
      date: serializer.fromJson<DateTime>(json['date']),
      name: serializer.fromJson<String>(json['name']),
      projectId: serializer.fromJson<int>(json['projectId']),
      taskId: serializer.fromJson<int>(json['taskId']),
      unitAmount: serializer.fromJson<double?>(json['unitAmount']),
      currentStatus: i2.$AnalyticLinesTable.$convertercurrentStatus
          .fromJson(serializer.fromJson<int>(json['currentStatus'])),
      lastTicked: serializer.fromJson<DateTime?>(json['lastTicked']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      showTimeControl: serializer.fromJson<String?>(json['showTimeControl']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createDate': serializer.toJson<DateTime>(createDate),
      'writeDate': serializer.toJson<DateTime>(writeDate),
      'isMarkedAsDeleted': serializer.toJson<bool>(isMarkedAsDeleted),
      'backendId': serializer.toJson<String>(backendId),
      'date': serializer.toJson<DateTime>(date),
      'name': serializer.toJson<String>(name),
      'projectId': serializer.toJson<int>(projectId),
      'taskId': serializer.toJson<int>(taskId),
      'unitAmount': serializer.toJson<double?>(unitAmount),
      'currentStatus': serializer.toJson<int>(
          i2.$AnalyticLinesTable.$convertercurrentStatus.toJson(currentStatus)),
      'lastTicked': serializer.toJson<DateTime?>(lastTicked),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'showTimeControl': serializer.toJson<String?>(showTimeControl),
    };
  }

  i2.AnalyticLine copyWith(
          {int? id,
          DateTime? createDate,
          DateTime? writeDate,
          bool? isMarkedAsDeleted,
          String? backendId,
          DateTime? date,
          String? name,
          int? projectId,
          int? taskId,
          i0.Value<double?> unitAmount = const i0.Value.absent(),
          i3.TimerStatus? currentStatus,
          i0.Value<DateTime?> lastTicked = const i0.Value.absent(),
          bool? isFavorite,
          i0.Value<DateTime?> startTime = const i0.Value.absent(),
          i0.Value<DateTime?> endTime = const i0.Value.absent(),
          i0.Value<String?> showTimeControl = const i0.Value.absent()}) =>
      i2.AnalyticLine(
        id: id ?? this.id,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
        backendId: backendId ?? this.backendId,
        date: date ?? this.date,
        name: name ?? this.name,
        projectId: projectId ?? this.projectId,
        taskId: taskId ?? this.taskId,
        unitAmount: unitAmount.present ? unitAmount.value : this.unitAmount,
        currentStatus: currentStatus ?? this.currentStatus,
        lastTicked: lastTicked.present ? lastTicked.value : this.lastTicked,
        isFavorite: isFavorite ?? this.isFavorite,
        startTime: startTime.present ? startTime.value : this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        showTimeControl: showTimeControl.present
            ? showTimeControl.value
            : this.showTimeControl,
      );
  AnalyticLine copyWithCompanion(i2.AnalyticLinesCompanion data) {
    return AnalyticLine(
      id: data.id.present ? data.id.value : this.id,
      createDate:
          data.createDate.present ? data.createDate.value : this.createDate,
      writeDate: data.writeDate.present ? data.writeDate.value : this.writeDate,
      isMarkedAsDeleted: data.isMarkedAsDeleted.present
          ? data.isMarkedAsDeleted.value
          : this.isMarkedAsDeleted,
      backendId: data.backendId.present ? data.backendId.value : this.backendId,
      date: data.date.present ? data.date.value : this.date,
      name: data.name.present ? data.name.value : this.name,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      unitAmount:
          data.unitAmount.present ? data.unitAmount.value : this.unitAmount,
      currentStatus: data.currentStatus.present
          ? data.currentStatus.value
          : this.currentStatus,
      lastTicked:
          data.lastTicked.present ? data.lastTicked.value : this.lastTicked,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      showTimeControl: data.showTimeControl.present
          ? data.showTimeControl.value
          : this.showTimeControl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalyticLine(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('date: $date, ')
          ..write('name: $name, ')
          ..write('projectId: $projectId, ')
          ..write('taskId: $taskId, ')
          ..write('unitAmount: $unitAmount, ')
          ..write('currentStatus: $currentStatus, ')
          ..write('lastTicked: $lastTicked, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('showTimeControl: $showTimeControl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createDate,
      writeDate,
      isMarkedAsDeleted,
      backendId,
      date,
      name,
      projectId,
      taskId,
      unitAmount,
      currentStatus,
      lastTicked,
      isFavorite,
      startTime,
      endTime,
      showTimeControl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i2.AnalyticLine &&
          other.id == this.id &&
          other.createDate == this.createDate &&
          other.writeDate == this.writeDate &&
          other.isMarkedAsDeleted == this.isMarkedAsDeleted &&
          other.backendId == this.backendId &&
          other.date == this.date &&
          other.name == this.name &&
          other.projectId == this.projectId &&
          other.taskId == this.taskId &&
          other.unitAmount == this.unitAmount &&
          other.currentStatus == this.currentStatus &&
          other.lastTicked == this.lastTicked &&
          other.isFavorite == this.isFavorite &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.showTimeControl == this.showTimeControl);
}

class AnalyticLinesCompanion extends i0.UpdateCompanion<i2.AnalyticLine> {
  final i0.Value<int> id;
  final i0.Value<DateTime> createDate;
  final i0.Value<DateTime> writeDate;
  final i0.Value<bool> isMarkedAsDeleted;
  final i0.Value<String> backendId;
  final i0.Value<DateTime> date;
  final i0.Value<String> name;
  final i0.Value<int> projectId;
  final i0.Value<int> taskId;
  final i0.Value<double?> unitAmount;
  final i0.Value<i3.TimerStatus> currentStatus;
  final i0.Value<DateTime?> lastTicked;
  final i0.Value<bool> isFavorite;
  final i0.Value<DateTime?> startTime;
  final i0.Value<DateTime?> endTime;
  final i0.Value<String?> showTimeControl;
  final i0.Value<int> rowid;
  const AnalyticLinesCompanion({
    this.id = const i0.Value.absent(),
    this.createDate = const i0.Value.absent(),
    this.writeDate = const i0.Value.absent(),
    this.isMarkedAsDeleted = const i0.Value.absent(),
    this.backendId = const i0.Value.absent(),
    this.date = const i0.Value.absent(),
    this.name = const i0.Value.absent(),
    this.projectId = const i0.Value.absent(),
    this.taskId = const i0.Value.absent(),
    this.unitAmount = const i0.Value.absent(),
    this.currentStatus = const i0.Value.absent(),
    this.lastTicked = const i0.Value.absent(),
    this.isFavorite = const i0.Value.absent(),
    this.startTime = const i0.Value.absent(),
    this.endTime = const i0.Value.absent(),
    this.showTimeControl = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  AnalyticLinesCompanion.insert({
    required int id,
    required DateTime createDate,
    required DateTime writeDate,
    this.isMarkedAsDeleted = const i0.Value.absent(),
    required String backendId,
    required DateTime date,
    required String name,
    required int projectId,
    required int taskId,
    this.unitAmount = const i0.Value.absent(),
    this.currentStatus = const i0.Value.absent(),
    this.lastTicked = const i0.Value.absent(),
    this.isFavorite = const i0.Value.absent(),
    this.startTime = const i0.Value.absent(),
    this.endTime = const i0.Value.absent(),
    this.showTimeControl = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        createDate = i0.Value(createDate),
        writeDate = i0.Value(writeDate),
        backendId = i0.Value(backendId),
        date = i0.Value(date),
        name = i0.Value(name),
        projectId = i0.Value(projectId),
        taskId = i0.Value(taskId);
  static i0.Insertable<i2.AnalyticLine> custom({
    i0.Expression<int>? id,
    i0.Expression<DateTime>? createDate,
    i0.Expression<DateTime>? writeDate,
    i0.Expression<bool>? isMarkedAsDeleted,
    i0.Expression<String>? backendId,
    i0.Expression<DateTime>? date,
    i0.Expression<String>? name,
    i0.Expression<int>? projectId,
    i0.Expression<int>? taskId,
    i0.Expression<double>? unitAmount,
    i0.Expression<int>? currentStatus,
    i0.Expression<DateTime>? lastTicked,
    i0.Expression<bool>? isFavorite,
    i0.Expression<DateTime>? startTime,
    i0.Expression<DateTime>? endTime,
    i0.Expression<String>? showTimeControl,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (createDate != null) 'create_date': createDate,
      if (writeDate != null) 'write_date': writeDate,
      if (isMarkedAsDeleted != null) 'is_marked_as_deleted': isMarkedAsDeleted,
      if (backendId != null) 'backend_id': backendId,
      if (date != null) 'date': date,
      if (name != null) 'name': name,
      if (projectId != null) 'project_id': projectId,
      if (taskId != null) 'task_id': taskId,
      if (unitAmount != null) 'unit_amount': unitAmount,
      if (currentStatus != null) 'current_status': currentStatus,
      if (lastTicked != null) 'last_ticked': lastTicked,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (showTimeControl != null) 'show_time_control': showTimeControl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i2.AnalyticLinesCompanion copyWith(
      {i0.Value<int>? id,
      i0.Value<DateTime>? createDate,
      i0.Value<DateTime>? writeDate,
      i0.Value<bool>? isMarkedAsDeleted,
      i0.Value<String>? backendId,
      i0.Value<DateTime>? date,
      i0.Value<String>? name,
      i0.Value<int>? projectId,
      i0.Value<int>? taskId,
      i0.Value<double?>? unitAmount,
      i0.Value<i3.TimerStatus>? currentStatus,
      i0.Value<DateTime?>? lastTicked,
      i0.Value<bool>? isFavorite,
      i0.Value<DateTime?>? startTime,
      i0.Value<DateTime?>? endTime,
      i0.Value<String?>? showTimeControl,
      i0.Value<int>? rowid}) {
    return i2.AnalyticLinesCompanion(
      id: id ?? this.id,
      createDate: createDate ?? this.createDate,
      writeDate: writeDate ?? this.writeDate,
      isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
      backendId: backendId ?? this.backendId,
      date: date ?? this.date,
      name: name ?? this.name,
      projectId: projectId ?? this.projectId,
      taskId: taskId ?? this.taskId,
      unitAmount: unitAmount ?? this.unitAmount,
      currentStatus: currentStatus ?? this.currentStatus,
      lastTicked: lastTicked ?? this.lastTicked,
      isFavorite: isFavorite ?? this.isFavorite,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      showTimeControl: showTimeControl ?? this.showTimeControl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (createDate.present) {
      map['create_date'] = i0.Variable<DateTime>(createDate.value);
    }
    if (writeDate.present) {
      map['write_date'] = i0.Variable<DateTime>(writeDate.value);
    }
    if (isMarkedAsDeleted.present) {
      map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted.value);
    }
    if (backendId.present) {
      map['backend_id'] = i0.Variable<String>(backendId.value);
    }
    if (date.present) {
      map['date'] = i0.Variable<DateTime>(date.value);
    }
    if (name.present) {
      map['name'] = i0.Variable<String>(name.value);
    }
    if (projectId.present) {
      map['project_id'] = i0.Variable<int>(projectId.value);
    }
    if (taskId.present) {
      map['task_id'] = i0.Variable<int>(taskId.value);
    }
    if (unitAmount.present) {
      map['unit_amount'] = i0.Variable<double>(unitAmount.value);
    }
    if (currentStatus.present) {
      map['current_status'] = i0.Variable<int>(i2
          .$AnalyticLinesTable.$convertercurrentStatus
          .toSql(currentStatus.value));
    }
    if (lastTicked.present) {
      map['last_ticked'] = i0.Variable<DateTime>(lastTicked.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = i0.Variable<bool>(isFavorite.value);
    }
    if (startTime.present) {
      map['start_time'] = i0.Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = i0.Variable<DateTime>(endTime.value);
    }
    if (showTimeControl.present) {
      map['show_time_control'] = i0.Variable<String>(showTimeControl.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalyticLinesCompanion(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('date: $date, ')
          ..write('name: $name, ')
          ..write('projectId: $projectId, ')
          ..write('taskId: $taskId, ')
          ..write('unitAmount: $unitAmount, ')
          ..write('currentStatus: $currentStatus, ')
          ..write('lastTicked: $lastTicked, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('showTimeControl: $showTimeControl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectProjectsTable extends i4.ProjectProjects
    with i0.TableInfo<$ProjectProjectsTable, i2.ProjectProject> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectProjectsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _createDateMeta =
      const i0.VerificationMeta('createDate');
  @override
  late final i0.GeneratedColumn<DateTime> createDate =
      i0.GeneratedColumn<DateTime>('create_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _writeDateMeta =
      const i0.VerificationMeta('writeDate');
  @override
  late final i0.GeneratedColumn<DateTime> writeDate =
      i0.GeneratedColumn<DateTime>('write_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _isMarkedAsDeletedMeta =
      const i0.VerificationMeta('isMarkedAsDeleted');
  @override
  late final i0.GeneratedColumn<bool> isMarkedAsDeleted =
      i0.GeneratedColumn<bool>('is_marked_as_deleted', aliasedName, false,
          type: i0.DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'CHECK ("is_marked_as_deleted" IN (0, 1))'),
          defaultValue: const i5.Constant(false));
  static const i0.VerificationMeta _backendIdMeta =
      const i0.VerificationMeta('backendId');
  @override
  late final i0.GeneratedColumn<String> backendId = i0.GeneratedColumn<String>(
      'backend_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_backends (id)'));
  static const i0.VerificationMeta _activeMeta =
      const i0.VerificationMeta('active');
  @override
  late final i0.GeneratedColumn<bool> active = i0.GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: i0.DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const i5.Constant(true));
  static const i0.VerificationMeta _isFavoriteMeta =
      const i0.VerificationMeta('isFavorite');
  @override
  late final i0.GeneratedColumn<bool> isFavorite = i0.GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: i0.DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const i5.Constant(false));
  static const i0.VerificationMeta _colorMeta =
      const i0.VerificationMeta('color');
  @override
  late final i0.GeneratedColumn<int> color = i0.GeneratedColumn<int>(
      'color', aliasedName, true,
      type: i0.DriftSqlType.int, requiredDuringInsert: false);
  static const i0.VerificationMeta _nameMeta =
      const i0.VerificationMeta('name');
  @override
  late final i0.GeneratedColumn<String> name = i0.GeneratedColumn<String>(
      'name', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _taskCountMeta =
      const i0.VerificationMeta('taskCount');
  @override
  late final i0.GeneratedColumn<int> taskCount = i0.GeneratedColumn<int>(
      'task_count', aliasedName, false,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const i5.Constant(0));
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        createDate,
        writeDate,
        isMarkedAsDeleted,
        backendId,
        active,
        isFavorite,
        color,
        name,
        taskCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_projects';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i2.ProjectProject> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    } else if (isInserting) {
      context.missing(_createDateMeta);
    }
    if (data.containsKey('write_date')) {
      context.handle(_writeDateMeta,
          writeDate.isAcceptableOrUnknown(data['write_date']!, _writeDateMeta));
    } else if (isInserting) {
      context.missing(_writeDateMeta);
    }
    if (data.containsKey('is_marked_as_deleted')) {
      context.handle(
          _isMarkedAsDeletedMeta,
          isMarkedAsDeleted.isAcceptableOrUnknown(
              data['is_marked_as_deleted']!, _isMarkedAsDeletedMeta));
    }
    if (data.containsKey('backend_id')) {
      context.handle(_backendIdMeta,
          backendId.isAcceptableOrUnknown(data['backend_id']!, _backendIdMeta));
    } else if (isInserting) {
      context.missing(_backendIdMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('task_count')) {
      context.handle(_taskCountMeta,
          taskCount.isAcceptableOrUnknown(data['task_count']!, _taskCountMeta));
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {backendId, id};
  @override
  i2.ProjectProject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i2.ProjectProject(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}id'])!,
      createDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}create_date'])!,
      writeDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}write_date'])!,
      isMarkedAsDeleted: attachedDatabase.typeMapping.read(i0.DriftSqlType.bool,
          data['${effectivePrefix}is_marked_as_deleted'])!,
      backendId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}backend_id'])!,
      active: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.bool, data['${effectivePrefix}active'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      color: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}color']),
      name: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}name'])!,
      taskCount: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}task_count'])!,
    );
  }

  @override
  $ProjectProjectsTable createAlias(String alias) {
    return $ProjectProjectsTable(attachedDatabase, alias);
  }
}

class ProjectProject extends i0.DataClass
    implements i0.Insertable<i2.ProjectProject> {
  final int id;
  final DateTime createDate;
  final DateTime writeDate;
  final bool isMarkedAsDeleted;
  final String backendId;
  final bool active;
  final bool isFavorite;
  final int? color;
  final String name;
  final int taskCount;
  const ProjectProject(
      {required this.id,
      required this.createDate,
      required this.writeDate,
      required this.isMarkedAsDeleted,
      required this.backendId,
      required this.active,
      required this.isFavorite,
      this.color,
      required this.name,
      required this.taskCount});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['create_date'] = i0.Variable<DateTime>(createDate);
    map['write_date'] = i0.Variable<DateTime>(writeDate);
    map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted);
    map['backend_id'] = i0.Variable<String>(backendId);
    map['active'] = i0.Variable<bool>(active);
    map['is_favorite'] = i0.Variable<bool>(isFavorite);
    if (!nullToAbsent || color != null) {
      map['color'] = i0.Variable<int>(color);
    }
    map['name'] = i0.Variable<String>(name);
    map['task_count'] = i0.Variable<int>(taskCount);
    return map;
  }

  i2.ProjectProjectsCompanion toCompanion(bool nullToAbsent) {
    return i2.ProjectProjectsCompanion(
      id: i0.Value(id),
      createDate: i0.Value(createDate),
      writeDate: i0.Value(writeDate),
      isMarkedAsDeleted: i0.Value(isMarkedAsDeleted),
      backendId: i0.Value(backendId),
      active: i0.Value(active),
      isFavorite: i0.Value(isFavorite),
      color: color == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(color),
      name: i0.Value(name),
      taskCount: i0.Value(taskCount),
    );
  }

  factory ProjectProject.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return ProjectProject(
      id: serializer.fromJson<int>(json['id']),
      createDate: serializer.fromJson<DateTime>(json['createDate']),
      writeDate: serializer.fromJson<DateTime>(json['writeDate']),
      isMarkedAsDeleted: serializer.fromJson<bool>(json['isMarkedAsDeleted']),
      backendId: serializer.fromJson<String>(json['backendId']),
      active: serializer.fromJson<bool>(json['active']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      color: serializer.fromJson<int?>(json['color']),
      name: serializer.fromJson<String>(json['name']),
      taskCount: serializer.fromJson<int>(json['taskCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createDate': serializer.toJson<DateTime>(createDate),
      'writeDate': serializer.toJson<DateTime>(writeDate),
      'isMarkedAsDeleted': serializer.toJson<bool>(isMarkedAsDeleted),
      'backendId': serializer.toJson<String>(backendId),
      'active': serializer.toJson<bool>(active),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'color': serializer.toJson<int?>(color),
      'name': serializer.toJson<String>(name),
      'taskCount': serializer.toJson<int>(taskCount),
    };
  }

  i2.ProjectProject copyWith(
          {int? id,
          DateTime? createDate,
          DateTime? writeDate,
          bool? isMarkedAsDeleted,
          String? backendId,
          bool? active,
          bool? isFavorite,
          i0.Value<int?> color = const i0.Value.absent(),
          String? name,
          int? taskCount}) =>
      i2.ProjectProject(
        id: id ?? this.id,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
        backendId: backendId ?? this.backendId,
        active: active ?? this.active,
        isFavorite: isFavorite ?? this.isFavorite,
        color: color.present ? color.value : this.color,
        name: name ?? this.name,
        taskCount: taskCount ?? this.taskCount,
      );
  ProjectProject copyWithCompanion(i2.ProjectProjectsCompanion data) {
    return ProjectProject(
      id: data.id.present ? data.id.value : this.id,
      createDate:
          data.createDate.present ? data.createDate.value : this.createDate,
      writeDate: data.writeDate.present ? data.writeDate.value : this.writeDate,
      isMarkedAsDeleted: data.isMarkedAsDeleted.present
          ? data.isMarkedAsDeleted.value
          : this.isMarkedAsDeleted,
      backendId: data.backendId.present ? data.backendId.value : this.backendId,
      active: data.active.present ? data.active.value : this.active,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      color: data.color.present ? data.color.value : this.color,
      name: data.name.present ? data.name.value : this.name,
      taskCount: data.taskCount.present ? data.taskCount.value : this.taskCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectProject(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('active: $active, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('color: $color, ')
          ..write('name: $name, ')
          ..write('taskCount: $taskCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createDate, writeDate, isMarkedAsDeleted,
      backendId, active, isFavorite, color, name, taskCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i2.ProjectProject &&
          other.id == this.id &&
          other.createDate == this.createDate &&
          other.writeDate == this.writeDate &&
          other.isMarkedAsDeleted == this.isMarkedAsDeleted &&
          other.backendId == this.backendId &&
          other.active == this.active &&
          other.isFavorite == this.isFavorite &&
          other.color == this.color &&
          other.name == this.name &&
          other.taskCount == this.taskCount);
}

class ProjectProjectsCompanion extends i0.UpdateCompanion<i2.ProjectProject> {
  final i0.Value<int> id;
  final i0.Value<DateTime> createDate;
  final i0.Value<DateTime> writeDate;
  final i0.Value<bool> isMarkedAsDeleted;
  final i0.Value<String> backendId;
  final i0.Value<bool> active;
  final i0.Value<bool> isFavorite;
  final i0.Value<int?> color;
  final i0.Value<String> name;
  final i0.Value<int> taskCount;
  final i0.Value<int> rowid;
  const ProjectProjectsCompanion({
    this.id = const i0.Value.absent(),
    this.createDate = const i0.Value.absent(),
    this.writeDate = const i0.Value.absent(),
    this.isMarkedAsDeleted = const i0.Value.absent(),
    this.backendId = const i0.Value.absent(),
    this.active = const i0.Value.absent(),
    this.isFavorite = const i0.Value.absent(),
    this.color = const i0.Value.absent(),
    this.name = const i0.Value.absent(),
    this.taskCount = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  ProjectProjectsCompanion.insert({
    required int id,
    required DateTime createDate,
    required DateTime writeDate,
    this.isMarkedAsDeleted = const i0.Value.absent(),
    required String backendId,
    this.active = const i0.Value.absent(),
    this.isFavorite = const i0.Value.absent(),
    this.color = const i0.Value.absent(),
    required String name,
    this.taskCount = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        createDate = i0.Value(createDate),
        writeDate = i0.Value(writeDate),
        backendId = i0.Value(backendId),
        name = i0.Value(name);
  static i0.Insertable<i2.ProjectProject> custom({
    i0.Expression<int>? id,
    i0.Expression<DateTime>? createDate,
    i0.Expression<DateTime>? writeDate,
    i0.Expression<bool>? isMarkedAsDeleted,
    i0.Expression<String>? backendId,
    i0.Expression<bool>? active,
    i0.Expression<bool>? isFavorite,
    i0.Expression<int>? color,
    i0.Expression<String>? name,
    i0.Expression<int>? taskCount,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (createDate != null) 'create_date': createDate,
      if (writeDate != null) 'write_date': writeDate,
      if (isMarkedAsDeleted != null) 'is_marked_as_deleted': isMarkedAsDeleted,
      if (backendId != null) 'backend_id': backendId,
      if (active != null) 'active': active,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (color != null) 'color': color,
      if (name != null) 'name': name,
      if (taskCount != null) 'task_count': taskCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i2.ProjectProjectsCompanion copyWith(
      {i0.Value<int>? id,
      i0.Value<DateTime>? createDate,
      i0.Value<DateTime>? writeDate,
      i0.Value<bool>? isMarkedAsDeleted,
      i0.Value<String>? backendId,
      i0.Value<bool>? active,
      i0.Value<bool>? isFavorite,
      i0.Value<int?>? color,
      i0.Value<String>? name,
      i0.Value<int>? taskCount,
      i0.Value<int>? rowid}) {
    return i2.ProjectProjectsCompanion(
      id: id ?? this.id,
      createDate: createDate ?? this.createDate,
      writeDate: writeDate ?? this.writeDate,
      isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
      backendId: backendId ?? this.backendId,
      active: active ?? this.active,
      isFavorite: isFavorite ?? this.isFavorite,
      color: color ?? this.color,
      name: name ?? this.name,
      taskCount: taskCount ?? this.taskCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (createDate.present) {
      map['create_date'] = i0.Variable<DateTime>(createDate.value);
    }
    if (writeDate.present) {
      map['write_date'] = i0.Variable<DateTime>(writeDate.value);
    }
    if (isMarkedAsDeleted.present) {
      map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted.value);
    }
    if (backendId.present) {
      map['backend_id'] = i0.Variable<String>(backendId.value);
    }
    if (active.present) {
      map['active'] = i0.Variable<bool>(active.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = i0.Variable<bool>(isFavorite.value);
    }
    if (color.present) {
      map['color'] = i0.Variable<int>(color.value);
    }
    if (name.present) {
      map['name'] = i0.Variable<String>(name.value);
    }
    if (taskCount.present) {
      map['task_count'] = i0.Variable<int>(taskCount.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectProjectsCompanion(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('active: $active, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('color: $color, ')
          ..write('name: $name, ')
          ..write('taskCount: $taskCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectTasksTable extends i4.ProjectTasks
    with i0.TableInfo<$ProjectTasksTable, i2.ProjectTask> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectTasksTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _createDateMeta =
      const i0.VerificationMeta('createDate');
  @override
  late final i0.GeneratedColumn<DateTime> createDate =
      i0.GeneratedColumn<DateTime>('create_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _writeDateMeta =
      const i0.VerificationMeta('writeDate');
  @override
  late final i0.GeneratedColumn<DateTime> writeDate =
      i0.GeneratedColumn<DateTime>('write_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _isMarkedAsDeletedMeta =
      const i0.VerificationMeta('isMarkedAsDeleted');
  @override
  late final i0.GeneratedColumn<bool> isMarkedAsDeleted =
      i0.GeneratedColumn<bool>('is_marked_as_deleted', aliasedName, false,
          type: i0.DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'CHECK ("is_marked_as_deleted" IN (0, 1))'),
          defaultValue: const i5.Constant(false));
  static const i0.VerificationMeta _backendIdMeta =
      const i0.VerificationMeta('backendId');
  @override
  late final i0.GeneratedColumn<String> backendId = i0.GeneratedColumn<String>(
      'backend_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_backends (id)'));
  static const i0.VerificationMeta _activeMeta =
      const i0.VerificationMeta('active');
  @override
  late final i0.GeneratedColumn<bool> active = i0.GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: i0.DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const i5.Constant(true));
  static const i0.VerificationMeta _colorMeta =
      const i0.VerificationMeta('color');
  @override
  late final i0.GeneratedColumn<int> color = i0.GeneratedColumn<int>(
      'color', aliasedName, true,
      type: i0.DriftSqlType.int, requiredDuringInsert: false);
  static const i0.VerificationMeta _dateDeadlineMeta =
      const i0.VerificationMeta('dateDeadline');
  @override
  late final i0.GeneratedColumn<DateTime> dateDeadline =
      i0.GeneratedColumn<DateTime>('date_deadline', aliasedName, true,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: false);
  static const i0.VerificationMeta _dateEndMeta =
      const i0.VerificationMeta('dateEnd');
  @override
  late final i0.GeneratedColumn<DateTime> dateEnd =
      i0.GeneratedColumn<DateTime>('date_end', aliasedName, true,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: false);
  static const i0.VerificationMeta _descriptionMeta =
      const i0.VerificationMeta('description');
  @override
  late final i0.GeneratedColumn<String> description =
      i0.GeneratedColumn<String>('description', aliasedName, true,
          type: i0.DriftSqlType.string, requiredDuringInsert: false);
  static const i0.VerificationMeta _nameMeta =
      const i0.VerificationMeta('name');
  @override
  late final i0.GeneratedColumn<String> name = i0.GeneratedColumn<String>(
      'name', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _priorityMeta =
      const i0.VerificationMeta('priority');
  @override
  late final i0.GeneratedColumn<String> priority = i0.GeneratedColumn<String>(
      'priority', aliasedName, true,
      type: i0.DriftSqlType.string, requiredDuringInsert: false);
  static const i0.VerificationMeta _projectIdMeta =
      const i0.VerificationMeta('projectId');
  @override
  late final i0.GeneratedColumn<int> projectId = i0.GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES project_projects (id) ON DELETE RESTRICT'));
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        createDate,
        writeDate,
        isMarkedAsDeleted,
        backendId,
        active,
        color,
        dateDeadline,
        dateEnd,
        description,
        name,
        priority,
        projectId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_tasks';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i2.ProjectTask> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    } else if (isInserting) {
      context.missing(_createDateMeta);
    }
    if (data.containsKey('write_date')) {
      context.handle(_writeDateMeta,
          writeDate.isAcceptableOrUnknown(data['write_date']!, _writeDateMeta));
    } else if (isInserting) {
      context.missing(_writeDateMeta);
    }
    if (data.containsKey('is_marked_as_deleted')) {
      context.handle(
          _isMarkedAsDeletedMeta,
          isMarkedAsDeleted.isAcceptableOrUnknown(
              data['is_marked_as_deleted']!, _isMarkedAsDeletedMeta));
    }
    if (data.containsKey('backend_id')) {
      context.handle(_backendIdMeta,
          backendId.isAcceptableOrUnknown(data['backend_id']!, _backendIdMeta));
    } else if (isInserting) {
      context.missing(_backendIdMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('date_deadline')) {
      context.handle(
          _dateDeadlineMeta,
          dateDeadline.isAcceptableOrUnknown(
              data['date_deadline']!, _dateDeadlineMeta));
    }
    if (data.containsKey('date_end')) {
      context.handle(_dateEndMeta,
          dateEnd.isAcceptableOrUnknown(data['date_end']!, _dateEndMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {backendId, id};
  @override
  i2.ProjectTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i2.ProjectTask(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}id'])!,
      createDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}create_date'])!,
      writeDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}write_date'])!,
      isMarkedAsDeleted: attachedDatabase.typeMapping.read(i0.DriftSqlType.bool,
          data['${effectivePrefix}is_marked_as_deleted'])!,
      backendId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}backend_id'])!,
      active: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.bool, data['${effectivePrefix}active'])!,
      color: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}color']),
      dateDeadline: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}date_deadline']),
      dateEnd: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}date_end']),
      description: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}description']),
      name: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}name'])!,
      priority: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}priority']),
      projectId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}project_id'])!,
    );
  }

  @override
  $ProjectTasksTable createAlias(String alias) {
    return $ProjectTasksTable(attachedDatabase, alias);
  }
}

class ProjectTask extends i0.DataClass
    implements i0.Insertable<i2.ProjectTask> {
  final int id;
  final DateTime createDate;
  final DateTime writeDate;
  final bool isMarkedAsDeleted;
  final String backendId;
  final bool active;
  final int? color;
  final DateTime? dateDeadline;
  final DateTime? dateEnd;
  final String? description;
  final String name;
  final String? priority;
  final int projectId;
  const ProjectTask(
      {required this.id,
      required this.createDate,
      required this.writeDate,
      required this.isMarkedAsDeleted,
      required this.backendId,
      required this.active,
      this.color,
      this.dateDeadline,
      this.dateEnd,
      this.description,
      required this.name,
      this.priority,
      required this.projectId});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['create_date'] = i0.Variable<DateTime>(createDate);
    map['write_date'] = i0.Variable<DateTime>(writeDate);
    map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted);
    map['backend_id'] = i0.Variable<String>(backendId);
    map['active'] = i0.Variable<bool>(active);
    if (!nullToAbsent || color != null) {
      map['color'] = i0.Variable<int>(color);
    }
    if (!nullToAbsent || dateDeadline != null) {
      map['date_deadline'] = i0.Variable<DateTime>(dateDeadline);
    }
    if (!nullToAbsent || dateEnd != null) {
      map['date_end'] = i0.Variable<DateTime>(dateEnd);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = i0.Variable<String>(description);
    }
    map['name'] = i0.Variable<String>(name);
    if (!nullToAbsent || priority != null) {
      map['priority'] = i0.Variable<String>(priority);
    }
    map['project_id'] = i0.Variable<int>(projectId);
    return map;
  }

  i2.ProjectTasksCompanion toCompanion(bool nullToAbsent) {
    return i2.ProjectTasksCompanion(
      id: i0.Value(id),
      createDate: i0.Value(createDate),
      writeDate: i0.Value(writeDate),
      isMarkedAsDeleted: i0.Value(isMarkedAsDeleted),
      backendId: i0.Value(backendId),
      active: i0.Value(active),
      color: color == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(color),
      dateDeadline: dateDeadline == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(dateDeadline),
      dateEnd: dateEnd == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(dateEnd),
      description: description == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(description),
      name: i0.Value(name),
      priority: priority == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(priority),
      projectId: i0.Value(projectId),
    );
  }

  factory ProjectTask.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return ProjectTask(
      id: serializer.fromJson<int>(json['id']),
      createDate: serializer.fromJson<DateTime>(json['createDate']),
      writeDate: serializer.fromJson<DateTime>(json['writeDate']),
      isMarkedAsDeleted: serializer.fromJson<bool>(json['isMarkedAsDeleted']),
      backendId: serializer.fromJson<String>(json['backendId']),
      active: serializer.fromJson<bool>(json['active']),
      color: serializer.fromJson<int?>(json['color']),
      dateDeadline: serializer.fromJson<DateTime?>(json['dateDeadline']),
      dateEnd: serializer.fromJson<DateTime?>(json['dateEnd']),
      description: serializer.fromJson<String?>(json['description']),
      name: serializer.fromJson<String>(json['name']),
      priority: serializer.fromJson<String?>(json['priority']),
      projectId: serializer.fromJson<int>(json['projectId']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createDate': serializer.toJson<DateTime>(createDate),
      'writeDate': serializer.toJson<DateTime>(writeDate),
      'isMarkedAsDeleted': serializer.toJson<bool>(isMarkedAsDeleted),
      'backendId': serializer.toJson<String>(backendId),
      'active': serializer.toJson<bool>(active),
      'color': serializer.toJson<int?>(color),
      'dateDeadline': serializer.toJson<DateTime?>(dateDeadline),
      'dateEnd': serializer.toJson<DateTime?>(dateEnd),
      'description': serializer.toJson<String?>(description),
      'name': serializer.toJson<String>(name),
      'priority': serializer.toJson<String?>(priority),
      'projectId': serializer.toJson<int>(projectId),
    };
  }

  i2.ProjectTask copyWith(
          {int? id,
          DateTime? createDate,
          DateTime? writeDate,
          bool? isMarkedAsDeleted,
          String? backendId,
          bool? active,
          i0.Value<int?> color = const i0.Value.absent(),
          i0.Value<DateTime?> dateDeadline = const i0.Value.absent(),
          i0.Value<DateTime?> dateEnd = const i0.Value.absent(),
          i0.Value<String?> description = const i0.Value.absent(),
          String? name,
          i0.Value<String?> priority = const i0.Value.absent(),
          int? projectId}) =>
      i2.ProjectTask(
        id: id ?? this.id,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
        backendId: backendId ?? this.backendId,
        active: active ?? this.active,
        color: color.present ? color.value : this.color,
        dateDeadline:
            dateDeadline.present ? dateDeadline.value : this.dateDeadline,
        dateEnd: dateEnd.present ? dateEnd.value : this.dateEnd,
        description: description.present ? description.value : this.description,
        name: name ?? this.name,
        priority: priority.present ? priority.value : this.priority,
        projectId: projectId ?? this.projectId,
      );
  ProjectTask copyWithCompanion(i2.ProjectTasksCompanion data) {
    return ProjectTask(
      id: data.id.present ? data.id.value : this.id,
      createDate:
          data.createDate.present ? data.createDate.value : this.createDate,
      writeDate: data.writeDate.present ? data.writeDate.value : this.writeDate,
      isMarkedAsDeleted: data.isMarkedAsDeleted.present
          ? data.isMarkedAsDeleted.value
          : this.isMarkedAsDeleted,
      backendId: data.backendId.present ? data.backendId.value : this.backendId,
      active: data.active.present ? data.active.value : this.active,
      color: data.color.present ? data.color.value : this.color,
      dateDeadline: data.dateDeadline.present
          ? data.dateDeadline.value
          : this.dateDeadline,
      dateEnd: data.dateEnd.present ? data.dateEnd.value : this.dateEnd,
      description:
          data.description.present ? data.description.value : this.description,
      name: data.name.present ? data.name.value : this.name,
      priority: data.priority.present ? data.priority.value : this.priority,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectTask(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('active: $active, ')
          ..write('color: $color, ')
          ..write('dateDeadline: $dateDeadline, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('description: $description, ')
          ..write('name: $name, ')
          ..write('priority: $priority, ')
          ..write('projectId: $projectId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      createDate,
      writeDate,
      isMarkedAsDeleted,
      backendId,
      active,
      color,
      dateDeadline,
      dateEnd,
      description,
      name,
      priority,
      projectId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i2.ProjectTask &&
          other.id == this.id &&
          other.createDate == this.createDate &&
          other.writeDate == this.writeDate &&
          other.isMarkedAsDeleted == this.isMarkedAsDeleted &&
          other.backendId == this.backendId &&
          other.active == this.active &&
          other.color == this.color &&
          other.dateDeadline == this.dateDeadline &&
          other.dateEnd == this.dateEnd &&
          other.description == this.description &&
          other.name == this.name &&
          other.priority == this.priority &&
          other.projectId == this.projectId);
}

class ProjectTasksCompanion extends i0.UpdateCompanion<i2.ProjectTask> {
  final i0.Value<int> id;
  final i0.Value<DateTime> createDate;
  final i0.Value<DateTime> writeDate;
  final i0.Value<bool> isMarkedAsDeleted;
  final i0.Value<String> backendId;
  final i0.Value<bool> active;
  final i0.Value<int?> color;
  final i0.Value<DateTime?> dateDeadline;
  final i0.Value<DateTime?> dateEnd;
  final i0.Value<String?> description;
  final i0.Value<String> name;
  final i0.Value<String?> priority;
  final i0.Value<int> projectId;
  final i0.Value<int> rowid;
  const ProjectTasksCompanion({
    this.id = const i0.Value.absent(),
    this.createDate = const i0.Value.absent(),
    this.writeDate = const i0.Value.absent(),
    this.isMarkedAsDeleted = const i0.Value.absent(),
    this.backendId = const i0.Value.absent(),
    this.active = const i0.Value.absent(),
    this.color = const i0.Value.absent(),
    this.dateDeadline = const i0.Value.absent(),
    this.dateEnd = const i0.Value.absent(),
    this.description = const i0.Value.absent(),
    this.name = const i0.Value.absent(),
    this.priority = const i0.Value.absent(),
    this.projectId = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  ProjectTasksCompanion.insert({
    required int id,
    required DateTime createDate,
    required DateTime writeDate,
    this.isMarkedAsDeleted = const i0.Value.absent(),
    required String backendId,
    this.active = const i0.Value.absent(),
    this.color = const i0.Value.absent(),
    this.dateDeadline = const i0.Value.absent(),
    this.dateEnd = const i0.Value.absent(),
    this.description = const i0.Value.absent(),
    required String name,
    this.priority = const i0.Value.absent(),
    required int projectId,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        createDate = i0.Value(createDate),
        writeDate = i0.Value(writeDate),
        backendId = i0.Value(backendId),
        name = i0.Value(name),
        projectId = i0.Value(projectId);
  static i0.Insertable<i2.ProjectTask> custom({
    i0.Expression<int>? id,
    i0.Expression<DateTime>? createDate,
    i0.Expression<DateTime>? writeDate,
    i0.Expression<bool>? isMarkedAsDeleted,
    i0.Expression<String>? backendId,
    i0.Expression<bool>? active,
    i0.Expression<int>? color,
    i0.Expression<DateTime>? dateDeadline,
    i0.Expression<DateTime>? dateEnd,
    i0.Expression<String>? description,
    i0.Expression<String>? name,
    i0.Expression<String>? priority,
    i0.Expression<int>? projectId,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (createDate != null) 'create_date': createDate,
      if (writeDate != null) 'write_date': writeDate,
      if (isMarkedAsDeleted != null) 'is_marked_as_deleted': isMarkedAsDeleted,
      if (backendId != null) 'backend_id': backendId,
      if (active != null) 'active': active,
      if (color != null) 'color': color,
      if (dateDeadline != null) 'date_deadline': dateDeadline,
      if (dateEnd != null) 'date_end': dateEnd,
      if (description != null) 'description': description,
      if (name != null) 'name': name,
      if (priority != null) 'priority': priority,
      if (projectId != null) 'project_id': projectId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i2.ProjectTasksCompanion copyWith(
      {i0.Value<int>? id,
      i0.Value<DateTime>? createDate,
      i0.Value<DateTime>? writeDate,
      i0.Value<bool>? isMarkedAsDeleted,
      i0.Value<String>? backendId,
      i0.Value<bool>? active,
      i0.Value<int?>? color,
      i0.Value<DateTime?>? dateDeadline,
      i0.Value<DateTime?>? dateEnd,
      i0.Value<String?>? description,
      i0.Value<String>? name,
      i0.Value<String?>? priority,
      i0.Value<int>? projectId,
      i0.Value<int>? rowid}) {
    return i2.ProjectTasksCompanion(
      id: id ?? this.id,
      createDate: createDate ?? this.createDate,
      writeDate: writeDate ?? this.writeDate,
      isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
      backendId: backendId ?? this.backendId,
      active: active ?? this.active,
      color: color ?? this.color,
      dateDeadline: dateDeadline ?? this.dateDeadline,
      dateEnd: dateEnd ?? this.dateEnd,
      description: description ?? this.description,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (createDate.present) {
      map['create_date'] = i0.Variable<DateTime>(createDate.value);
    }
    if (writeDate.present) {
      map['write_date'] = i0.Variable<DateTime>(writeDate.value);
    }
    if (isMarkedAsDeleted.present) {
      map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted.value);
    }
    if (backendId.present) {
      map['backend_id'] = i0.Variable<String>(backendId.value);
    }
    if (active.present) {
      map['active'] = i0.Variable<bool>(active.value);
    }
    if (color.present) {
      map['color'] = i0.Variable<int>(color.value);
    }
    if (dateDeadline.present) {
      map['date_deadline'] = i0.Variable<DateTime>(dateDeadline.value);
    }
    if (dateEnd.present) {
      map['date_end'] = i0.Variable<DateTime>(dateEnd.value);
    }
    if (description.present) {
      map['description'] = i0.Variable<String>(description.value);
    }
    if (name.present) {
      map['name'] = i0.Variable<String>(name.value);
    }
    if (priority.present) {
      map['priority'] = i0.Variable<String>(priority.value);
    }
    if (projectId.present) {
      map['project_id'] = i0.Variable<int>(projectId.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectTasksCompanion(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('active: $active, ')
          ..write('color: $color, ')
          ..write('dateDeadline: $dateDeadline, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('description: $description, ')
          ..write('name: $name, ')
          ..write('priority: $priority, ')
          ..write('projectId: $projectId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

i0.Index get analyticLinesProjectTask => i0.Index('analytic_lines_project_task',
    'CREATE INDEX analytic_lines_project_task ON analytic_lines (project_id, task_id)');
i0.Index get analyticLinesStatus => i0.Index('analytic_lines_status',
    'CREATE INDEX analytic_lines_status ON analytic_lines (current_status)');
i0.Index get analyticLinesFavorite => i0.Index('analytic_lines_favorite',
    'CREATE INDEX analytic_lines_favorite ON analytic_lines (is_favorite)');
i0.Index get projectProjectsName => i0.Index('project_projects_name',
    'CREATE INDEX project_projects_name ON project_projects (name)');
i0.Index get projectProjectsFavorite => i0.Index('project_projects_favorite',
    'CREATE INDEX project_projects_favorite ON project_projects (is_favorite)');
i0.Index get projectTasksProject => i0.Index('project_tasks_project',
    'CREATE INDEX project_tasks_project ON project_tasks (project_id)');
i0.Index get projectTasksName => i0.Index('project_tasks_name',
    'CREATE INDEX project_tasks_name ON project_tasks (name)');
