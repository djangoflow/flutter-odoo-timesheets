import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetWithTaskProjectListCubit
    extends CrudListCubit<TimesheetWithTaskProject, TimesheetPaginationFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  TimesheetWithTaskProjectListCubit({required super.repository});
}

class FavoriteTimesheetWithTaskProjectListCubit
    extends TimesheetWithTaskProjectListCubit {
  FavoriteTimesheetWithTaskProjectListCubit({required super.repository});
}

class LocalTimesheetWithTaskProjectListCubit
    extends TimesheetWithTaskProjectListCubit {
  LocalTimesheetWithTaskProjectListCubit({required super.repository});
}
