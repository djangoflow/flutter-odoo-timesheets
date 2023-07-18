import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/project/data/repositories/projects_repository.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/features/timesheet/data/repositories/timesheets_repository.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

export 'timesheet_retrieve_filter.dart';

typedef TimesheetDataState
    = Data<TimesheetWithTaskExternalData?, TimesheetRetrieveFilter>;

class TimesheetDataCubit
    extends DataCubit<TimesheetWithTaskExternalData?, TimesheetRetrieveFilter>
    with CubitMaybeEmit {
  final TimesheetsRepository timesheetsRepository;
  final TasksRepository tasksRepository;
  final ProjectsRepository projectsRepository;

  TimesheetDataCubit(
      this.timesheetsRepository, this.tasksRepository, this.projectsRepository)
      : super(
          ListBlocUtil.dataLoader<TimesheetWithTaskExternalData?,
              TimesheetRetrieveFilter>(
            loader: ([filter]) {
              if (filter == null) {
                throw ArgumentError.notNull('taskId');
              }
              final timesheetWithTaskExternalData = timesheetsRepository
                  .getTimesheetWithTaskExternalDataById(filter.timesheetId);

              return timesheetWithTaskExternalData;
            },
          ),
        );

  Future<void> updateTimesheet(Timesheet timesheet,
      TaskWithProjectExternalData taskWithProjectExternalData) async {
    await timesheetsRepository.update(timesheet);
    await tasksRepository.update(
      taskWithProjectExternalData.taskWithExternalData.task,
    );
    await projectsRepository.update(
      taskWithProjectExternalData.projectWithExternalData.project,
    );

    final timesheetWithTaskExternalData = await timesheetsRepository
        .getTimesheetWithTaskExternalDataById(timesheet.id);

    if (timesheetWithTaskExternalData == null) {
      throw ArgumentError.notNull('timesheetWithTaskExternalData');
    }

    if (state.data != null) {
      emit(
        Data(
          data: timesheetWithTaskExternalData,
          filter: state.filter,
        ),
      );
    }
  }

  Future<void> deleteTimesheet(Timesheet timesheet) async {
    await timesheetsRepository.delete(timesheet);
    emit(const Data.empty());
  }

  Future<void> refreshTimesheet() async {
    await load();
  }
}
