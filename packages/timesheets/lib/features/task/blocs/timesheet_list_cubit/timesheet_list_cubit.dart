import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';

import 'package:timesheets/utils/utils.dart';

export 'timesheet_list_filter.dart';

// TODO rename to single case
typedef TimesheetListState = Data<List<Timesheet>, TimesheetListFilter?>;

class TimesheetListCubit extends ListCubit<Timesheet, TimesheetListFilter?>
    with CubitMaybeEmit {
  final TimesheetsRepository timesheetsRepository;
  TimesheetListCubit(this.timesheetsRepository)
      : super(
          ListBlocUtil.listLoader<Timesheet, TimesheetListFilter?>(
            loader: ([filter]) => timesheetsRepository.getTimesheets(
              filter?.taskId,
            ),
          ),
        );

  Future<void> createTimesheet(TimesheetsCompanion timesheetsCompanion) async {
    final timesheetId =
        await timesheetsRepository.createTimeSheet(timesheetsCompanion);
    final timesheet = await timesheetsRepository.getTimesheetById(timesheetId);
    if (timesheet == null) {
      throw Exception('Timesheet not found');
    }

    if (state is Empty) {
      emit(
        Data(
          data: [timesheet],
          filter: state.filter,
        ),
      );
    } else {
      emit(
        state.copyWith(
          data: [
            timesheet,
            ...state.data!,
          ],
        ),
      );
    }
  }

  Future<void> updateTimesheet(Timesheet timesheet) async {
    await timesheetsRepository.updateTimesheet(timesheet);
    final updatedTimesheet =
        await timesheetsRepository.getTimesheetById(timesheet.id);
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.id == timesheet.id) updatedTimesheet! else t,
        ],
      ),
    );
  }

  Future<void> deleteTimesheet(Timesheet timesheet) async {
    await timesheetsRepository.deleteTimesheet(timesheet);
    emit(
      state.copyWith(
        data: [
          for (final t in state.data!)
            if (t.id != timesheet.id) t,
        ],
      ),
    );
  }
}
