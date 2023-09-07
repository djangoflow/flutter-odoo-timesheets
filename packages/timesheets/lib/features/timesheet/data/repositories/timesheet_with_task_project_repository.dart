import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

abstract class TimesheetWithTaskProjectRepository extends CrudRepository<
    TimesheetWithTaskProject, TimesheetPaginationFilter> {}
