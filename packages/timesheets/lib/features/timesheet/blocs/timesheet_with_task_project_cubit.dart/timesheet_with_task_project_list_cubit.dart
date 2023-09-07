import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetWithTaskProjectListCubit
    extends CrudListCubit<TimesheetWithTaskProject, TimesheetPaginatedFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  TimesheetWithTaskProjectListCubit({required super.repository});
}
