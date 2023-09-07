import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/blocs/crud_data_cubit/crud_data_cubit.dart';
import 'package:timesheets/features/timesheet/blocs/timesheet_data_cubit/timesheet_data_filter.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

typedef TimesheetWithTaskProjectDataCubitState
    = Data<TimesheetWithTaskProject, TimesheetDataFilter>;

class TimesheetWithTaskProjectDataCubit extends CrudDataCubit<
    TimesheetWithTaskProject,
    TimesheetPaginationFilter,
    TimesheetDataFilter> with ActiveStateMixin {
  // Plug in InMemoryRepository or RemoteRepository etc here
  TimesheetWithTaskProjectDataCubit({required super.repository});
}
