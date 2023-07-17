// import 'package:drift/drift.dart';
// import 'package:timesheets/features/app/data/db/app_database.dart';
// import 'package:timesheets/features/task/task.dart';

// part 'timesheets_dao.g.dart';

// @DriftAccessor(tables: [Timesheets])
// class TimesheetsDao extends DatabaseAccessor<AppDatabase>
//     with _$TimesheetsDaoMixin {
//   TimesheetsDao(AppDatabase db) : super(db);

//   // Timesheets CRUD operations
//   Future<int> createTimesheet(TimesheetsCompanion timesheetsCompanion) =>
//       into(timesheets).insert(timesheetsCompanion);

//   Future<void> deleteTimesheet(Timesheet timesheet) =>
//       delete(timesheets).delete(timesheet);

//   Future<void> deleteTimesheetsByTaskId(int taskId) =>
//       (delete(timesheets)..where((th) => th.taskId.equals(taskId))).go();
//   // in latest item at top order
//   Future<List<Timesheet>> getTimesheets(int? taskId) => taskId == null
//       ? (select(timesheets)
//             ..orderBy([
//               (th) => OrderingTerm(expression: th.id, mode: OrderingMode.desc),
//             ]))
//           .get()
//       : (select(timesheets)
//             ..where((th) => th.taskId.equals(taskId))
//             ..orderBy([
//               (th) => OrderingTerm(expression: th.id, mode: OrderingMode.desc),
//             ]))
//           .get();

//   Future<void> updateTimesheet(Timesheet timesheet) =>
//       update(timesheets).replace(timesheet);

//   Future<Timesheet?> getTimesheetById(int timesheetId) =>
//       (select(timesheets)..where((th) => th.id.equals(timesheetId)))
//           .getSingleOrNull();

//   Future<Timesheet> getTimesheetByTaskId(int timesheetId) async {
//     final timesheet = await (select(timesheets)
//           ..where((th) => th.taskId.equals(timesheetId)))
//         .getSingleOrNull();

//     if (timesheet == null) {
//       throw Exception('Timesheet not found');
//     }

//     return timesheet;
//   }
// }
