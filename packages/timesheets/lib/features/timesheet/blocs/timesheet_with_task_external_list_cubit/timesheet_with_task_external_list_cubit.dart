import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

export 'timesheet_with_task_external_list_filter.dart';

typedef TimesheetWithTaskExternalListState = Data<
    List<TimesheetWithTaskExternalData>, TimesheetWithTaskExternalListFilter>;

class TimesheetWithTaskExternalListCubit extends ListCubit<
    TimesheetWithTaskExternalData,
    TimesheetWithTaskExternalListFilter> with ActiveStateMixin {
  final TimesheetRepository timesheetRepository;

  TimesheetWithTaskExternalListCubit(this.timesheetRepository)
      : super(
          ListBlocUtil.listLoader<TimesheetWithTaskExternalData,
              TimesheetWithTaskExternalListFilter>(
            loader: ([filter]) =>
                timesheetRepository.getPaginatedTimesheetWithTaskProjectData(
              limit: filter?.limit ??
                  TimesheetWithTaskExternalListFilter.kPageSize,
              offset: filter?.offset,
              isLocal: filter?.isLocal,
              taskId: filter?.taskId,
              isEndDateNull: filter?.isEndDateNull,
              isProjectLocal: filter?.isProjectLocal,
              orderBy: filter?.orderingFilters
                  .map((e) => e.orderingTermBuilder)
                  .toList(),
              isFavorite: filter?.isFavorite,
            ),
          ),
        );

  // Need to implement this method
  Future<void> createTimesheetWithTaskAndProject(
      TimesheetsCompanion timesheetsCompanion,
      TasksCompanion tasksCompanion,
      ProjectsCompanion projectsCompanion) async {
    // final timesheetId = await timesheetRepository
    //     .createTimesheetWithTaskAndProject(
    //         timesheetsCompanion, tasksCompanion, projectsCompanion);
    // final timesheet = await timesheetRepository
    //     .getTimesheetWithTaskAndProjectById(timesheetId);
    // if (state is Empty) {
    //   emit(
    //     Data(
    //       data: [timesheet!],
    //       filter: state.filter,
    //     ),
    //   );
    // } else {
    //   emit(
    //     state.copyWith(
    //       data: [
    //         timesheet!,
    //         ...state.data!,
    //       ],
    //     ),
    //   );
    // }
  }

  // Need to implement this method
  Future<void> updateTimesheet(Timesheet timesheet) async {
    if (isActive == false) {
      return;
    }
    await timesheetRepository.update(timesheet);
    final updatedTimesheet =
        await timesheetRepository.getItemById(timesheet.id);
    if (updatedTimesheet != null && isActive) {
      emit(
        state.copyWith(
          data: state.data!
              .map((e) => e.timesheetExternalData.timesheet.id == timesheet.id
                  ? e.copyWith(
                      timesheetExternalData: e.timesheetExternalData.copyWith(
                        timesheet: updatedTimesheet,
                      ),
                    )
                  : e)
              .toList(),
        ),
      );
    } else {
      throw Exception('Timesheet not found with id ${timesheet.id}');
    }
  }
}

class FavoriteTimesheetWithTaskExternalListCubit
    extends TimesheetWithTaskExternalListCubit {
  FavoriteTimesheetWithTaskExternalListCubit(super.timesheetRepository);
}

class LocalTimesheetWithTaskExternalListCubit
    extends TimesheetWithTaskExternalListCubit {
  LocalTimesheetWithTaskExternalListCubit(super.timesheetRepository);
}

class OdooTimesheetWithTaskExternalListCubit
    extends TimesheetWithTaskExternalListCubit {
  OdooTimesheetWithTaskExternalListCubit(super.timesheetRepository);
}
