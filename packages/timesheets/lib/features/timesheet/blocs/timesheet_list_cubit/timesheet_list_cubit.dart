import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/sync/sync.dart';
import 'package:timesheets/features/timesheet/timesheet.dart';
import 'package:timesheets/utils/utils.dart';

typedef TimesheetListState = Data<List<TimesheetModel>, TimesheetListFilter>;

class TimesheetListCubit
    extends SyncableListCubit<TimesheetModel, TimesheetListFilter>
    with ActiveStateMixin {
  final TimesheetRepository timesheetRepository;

  TimesheetListCubit(this.timesheetRepository,
      {Future<List<TimesheetModel>> Function([TimesheetListFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.listLoader<TimesheetModel, TimesheetListFilter>(
                loader: ([filter]) => timesheetRepository.getAll(
                  offset: filter?.offset,
                  limit: filter?.limit,
                  projectId: filter?.projectId,
                  taskId: filter?.taskId,
                  returnOnlySecondary: true,
                  activeOnly: filter?.activeOnly,
                  favoriteOnly: filter?.favoriteOnly,
                ),
              ),
          timesheetRepository,
        );

  @override
  Future<TimesheetModel> updateItem(TimesheetModel model,
      {bool shouldUpdateSecondaryOnly = false}) async {
    if (!isActive) {
      return model;
    }
    return (repository as TimesheetRepository).update(
        model.copyWith(
          writeDate: DateTime.timestamp(),
        ),
        onlyUpdateSecondary: shouldUpdateSecondaryOnly);
  }
}

class TimesheetRelationalListCubit
    extends SyncableListCubit<TimesheetModel, TimesheetListFilter>
    with ActiveStateMixin {
  final TimesheetRelationalRepository timesheetRelationalRepository;

  TimesheetRelationalListCubit(this.timesheetRelationalRepository,
      {Future<List<TimesheetModel>> Function([TimesheetListFilter?])? loader})
      : super(
          loader ??
              ListBlocUtil.listLoader<TimesheetModel, TimesheetListFilter>(
                loader: ([filter]) => timesheetRelationalRepository.getAll(
                  offset: filter?.offset,
                  limit: filter?.limit,
                  projectId: filter?.projectId,
                  taskId: filter?.taskId,
                  returnOnlySecondary: true,
                  activeOnly: filter?.activeOnly,
                  favoriteOnly: filter?.favoriteOnly,
                ),
              ),
          timesheetRelationalRepository,
        );
  @override
  Future<TimesheetModel> updateItem(TimesheetModel model,
      {bool shouldUpdateSecondaryOnly = false}) async {
    if (!isActive) {
      return model;
    }
    emit(state.copyWith(
      data: state.data?.map((e) => e.id == model.id ? model : e).toList(),
    ));
    final updatedItem = await timesheetRelationalRepository.update(
      model.copyWith(
        writeDate: DateTime.timestamp(),
      ),
      onlyUpdateSecondary: shouldUpdateSecondaryOnly,
    );

    return updatedItem;
  }
}

class FavoriteTimesheetRelationalListCubit
    extends TimesheetRelationalListCubit {
  FavoriteTimesheetRelationalListCubit(
    super.timesheetRelationalRepository,
  ) : super(
          loader: ListBlocUtil.listLoader<TimesheetModel, TimesheetListFilter>(
            loader: ([filter]) => timesheetRelationalRepository.getAll(
              offset: filter?.offset,
              limit: filter?.limit,
              projectId: filter?.projectId,
              taskId: filter?.taskId,
              activeOnly: filter?.activeOnly,
              favoriteOnly: true,
              returnOnlySecondary: true,
            ),
          ),
        );
}
