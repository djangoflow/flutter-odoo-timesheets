import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetListCubit
    extends CrudListCubit<Timesheet, TimesheetPaginatedFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  TimesheetListCubit({required super.repository});
}

class FavoriteTimesheetListCubit extends TimesheetListCubit {
  FavoriteTimesheetListCubit({required super.repository});
}

class LocalTimesheetListCubit extends TimesheetListCubit {
  LocalTimesheetListCubit({required super.repository});
}
