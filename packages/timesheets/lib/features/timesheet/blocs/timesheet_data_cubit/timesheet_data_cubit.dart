// lib/features/timesheet/blocs/timesheet_data_cubit/timesheet_data_cubit.dart

import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/sync/blocs/syncable_data_cubit.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

typedef TimesheetDataState = Data<TimesheetModel, TimesheetRetrieveFilter>;

class TimesheetDataCubit
    extends SyncableDataCubit<TimesheetModel, TimesheetRetrieveFilter> {
  final TimesheetRepository timesheetRepository;

  TimesheetDataCubit(this.timesheetRepository,
      {Future<TimesheetModel> Function([TimesheetRetrieveFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.dataLoader<TimesheetModel, TimesheetRetrieveFilter>(
                loader: ([filter]) async {
                  final result = await timesheetRepository.getById(
                    filter!.id,
                    returnOnlySecondary: true,
                  );
                  if (result != null) {
                    return result;
                  } else {
                    throw Exception('Timesheet not found');
                  }
                },
              ),
          timesheetRepository,
        );

  @override
  Future<TimesheetModel> updateItem(
    TimesheetModel model, {
    bool onlyUpdateSecondary = false,
  }) async {
    final updatedObject = await timesheetRepository.update(
      model.copyWith(
        writeDate: DateTime.timestamp(),
      ),
      onlyUpdateSecondary: onlyUpdateSecondary,
    );
    update(updatedObject);
    return updatedObject;
  }
}

class TimesheetRelationalDataCubit
    extends SyncableDataCubit<TimesheetModel, TimesheetRetrieveFilter> {
  final TimesheetRelationalRepository timesheetRelationalRepository;

  TimesheetRelationalDataCubit(this.timesheetRelationalRepository,
      {Future<TimesheetModel> Function([TimesheetRetrieveFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.dataLoader<TimesheetModel, TimesheetRetrieveFilter>(
                loader: ([filter]) async {
                  final result = await timesheetRelationalRepository.getById(
                    filter!.id,
                    returnOnlySecondary: true,
                  );
                  if (result != null) {
                    return result;
                  } else {
                    throw Exception('Timesheet not found');
                  }
                },
              ),
          timesheetRelationalRepository,
        );

  @override
  Future<TimesheetModel> updateItem(
    TimesheetModel model, {
    bool onlyUpdateSecondary = false,
  }) async {
    final updatedObject = await timesheetRelationalRepository.update(
      model.copyWith(
        writeDate: DateTime.timestamp(),
      ),
      onlyUpdateSecondary: onlyUpdateSecondary,
    );
    update(updatedObject);
    return updatedObject;
  }
}
