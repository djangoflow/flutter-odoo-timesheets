import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/blocs/crud_data_cubit/crud_data_cubit.dart';
import 'package:timesheets/features/task/blocs/task_data_cubit/task_data_filter.dart';
import 'package:timesheets/features/task/task.dart';

typedef TaskDataCubitState = Data<Task, TaskDataFilter>;

class TaskDataCubit
    extends CrudDataCubit<Task, TaskPaginationFilter, TaskDataFilter> {
  TaskDataCubit({required super.repository});
}
