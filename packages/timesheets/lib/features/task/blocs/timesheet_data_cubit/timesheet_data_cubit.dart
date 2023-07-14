import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/task/task.dart';
import 'package:timesheets/utils/utils.dart';

export 'timesheet_retrieve_filter.dart';

typedef TimesheetDataState = Data<TimesheetWithTask?, TimesheetRetrieveFilter>;

class TimesheetDataCubit
    extends DataCubit<TimesheetWithTask?, TimesheetRetrieveFilter>
    with CubitMaybeEmit {
  final TimesheetsRepository timesheetsRepository;
  final TasksRepository tasksRepository;

  TimesheetDataCubit(this.timesheetsRepository, this.tasksRepository)
      : super(
          ListBlocUtil.dataLoader<TimesheetWithTask?, TimesheetRetrieveFilter>(
            loader: ([filter]) {
              if (filter == null) {
                throw ArgumentError.notNull('taskId');
              }
              final timesheet = timesheetsRepository
                  .getTimesheetById(filter.timesheetId)
                  .then((timesheet) async {
                if (timesheet == null) {
                  throw ArgumentError.notNull('timesheet');
                }
                final taskWithProject = await tasksRepository
                    .getTaskWithProjectById(timesheet.taskId);
                if (taskWithProject == null) {
                  throw ArgumentError.notNull('task');
                }
                return TimesheetWithTask(
                  timesheet: timesheet,
                  taskWithProject: taskWithProject,
                );
              });

              return timesheet;
            },
          ),
        );

  Future<void> updateTimesheet(
      Timesheet timesheet, TaskWithProject taskWithProject) async {
    await timesheetsRepository.updateTimesheet(timesheet);
    await tasksRepository.updateTaskWithProject(
        task: taskWithProject.task, project: taskWithProject.project);
    final updatedTaskWithProject =
        await tasksRepository.getTaskWithProjectById(taskWithProject.task.id);
    if (updatedTaskWithProject == null) {
      throw ArgumentError.notNull('updatedTaskWithProject');
    }

    if (state.data != null) {
      emit(
        Data(
          data: state.data!.copyWith(
            timesheet: timesheet,
            taskWithProject: updatedTaskWithProject,
          ),
          filter: state.filter,
        ),
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
