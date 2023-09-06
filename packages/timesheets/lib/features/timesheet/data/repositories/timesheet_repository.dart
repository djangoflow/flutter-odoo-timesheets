import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

abstract class TimesheetRepository
    extends CrudRepository<Timesheet, TimesheetPaginatedFilter> {}
