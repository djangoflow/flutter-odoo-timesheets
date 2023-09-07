import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_data_cubit/timesheet_data_filter.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';

class TimesheetListCubit extends CrudListCubit<Timesheet,
    TimesheetPaginationFilter, TimesheetDataFilter> {
  // Plug in InMemoryRepository or RemoteRepository etc here
  TimesheetListCubit({required super.repository});
}

class FavoriteTimesheetListCubit extends TimesheetListCubit {
  FavoriteTimesheetListCubit({required super.repository});
}

class LocalTimesheetListCubit extends TimesheetListCubit {
  LocalTimesheetListCubit({required super.repository});
}
