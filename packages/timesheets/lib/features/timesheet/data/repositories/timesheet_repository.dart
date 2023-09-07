import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_data_cubit/timesheet_data_filter.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

abstract class TimesheetRepository extends CrudRepository<Timesheet,
    TimesheetPaginationFilter, TimesheetDataFilter> {}
