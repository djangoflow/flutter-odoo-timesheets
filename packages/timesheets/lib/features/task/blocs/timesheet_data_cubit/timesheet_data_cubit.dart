import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

import 'timesheet_retrieve_filter.dart';

export 'timesheet_retrieve_filter.dart';

typedef TimesheetDataState = Data<TimesheetWithTask?, TimesheetRetrieveFilter>;

class TimesheetDataCubit
    extends DataCubit<TimesheetWithTask?, TimesheetRetrieveFilter>
    with CubitMaybeEmit {
  final TimesheetsRepository timesheetsRepository;

  TimesheetDataCubit(this.timesheetsRepository)
      : super(
          ListBlocUtil.dataLoader<TimesheetWithTask?, TimesheetRetrieveFilter>(
            loader: ([filter]) {
              if (filter == null) {
                throw ArgumentError.notNull('taskId');
              }
              return timesheetsRepository
                  .getTimesheetWithTaskById(filter.timesheetId);
            },
          ),
        );

  Future<void> updateTimesheet(Timesheet timesheet) async {
    await timesheetsRepository.updateTimesheet(timesheet);
    if (state.data != null) {
      emit(
        Data(
            data: state.data!.copyWith(
              timesheet: timesheet,
            ),
            filter: state.filter),
      );
    }
  }

  Future<void> deleteTimesheet(Timesheet timesheet) async {
    await timesheetsRepository.deleteTimesheet(timesheet);
    emit(const Data.empty());
  }

  Future<void> refreshTimesheet() async {
    await load();
  }
}
