import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class ProjectListCubit
    extends CrudListCubit<Timesheet, TimesheetPaginatedFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  ProjectListCubit({required super.repository});
}
