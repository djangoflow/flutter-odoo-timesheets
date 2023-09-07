import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_data_cubit/timesheet_data_filter.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

typedef TimesheetWithTaskProjectListCubitState
    = Data<List<TimesheetWithTaskProject>, TimesheetPaginationFilter>;

class TimesheetWithTaskProjectListCubit extends CrudListCubit<
    TimesheetWithTaskProject,
    TimesheetPaginationFilter,
    TimesheetDataFilter> with ActiveStateMixin {
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
