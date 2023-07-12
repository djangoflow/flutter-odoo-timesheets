import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/odoo/data/models/odoo_timesheet.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';
import 'package:timesheets/features/task/task.dart';

import 'package:timesheets/utils/utils.dart';

export 'timesheet_list_filter.dart';

// TODO rename to single case
typedef TimesheetListState = Data<List<Timesheet>, TimesheetListFilter?>;

class TimesheetListCubit extends ListCubit<Timesheet, TimesheetListFilter?>
    with CubitMaybeEmit {
  final TimesheetsRepository timesheetsRepository;
  final OdooTimesheetRepository odooTimesheetRepository;
  final TasksRepository tasksRepository;
  final TimesheetBackendRepository timesheetBackendRepository;

  TimesheetListCubit({
    required this.timesheetsRepository,
    required this.odooTimesheetRepository,
    required this.tasksRepository,
    required this.timesheetBackendRepository,
  }) : super(
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

  Future<void> createTimesheetWithOdoo(
    TimesheetsCompanion timesheetsCompanion,
  ) async {
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

  Future<void> syncTimesheet(int timesheetId) async {
    final timesheet = await timesheetsRepository.getTimesheetById(timesheetId);
    if (timesheet == null) {
      throw Exception('Timesheet not found');
    }

    final taskWithProject =
        await tasksRepository.getTaskWithProjectById(timesheet.taskId);
    if (taskWithProject == null) {
      throw Exception('Task and Project not found');
    }

    final taskId = taskWithProject.task.onlineId;
    final projectId = taskWithProject.project.onlineId;

    if (taskId == null || projectId == null) {
      throw Exception('Task or Project not found');
    }

    final startTime = timesheet.startTime;
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final timesheetOnlineId = await odooTimesheetRepository.create(
      OdooTimesheet(
        projectId: projectId,
        taskId: taskId,
        startTime: formatter.format(startTime),
        endTime: formatter.format(
          startTime.add(
            Duration(seconds: timesheet.totalSpentSeconds),
          ),
        ),
        unitAmount: double.parse(
            (timesheet.totalSpentSeconds / 3600).toStringAsFixed(2)),
        name: taskWithProject.task.description,
      ),
    );

    await timesheetsRepository.updateTimesheet(
      timesheet.copyWith(
        onlineId: Value(timesheetOnlineId),
      ),
    );

    await timesheetBackendRepository.createTimesheetBackend(
      TimesheetBackendsCompanion(
        timesheetId: Value(timesheet.id),
        // TODO Fetch from backend via type
        backendId: const Value(1),
        lastSynced: Value(DateTime.now()),
      ),
    );
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
