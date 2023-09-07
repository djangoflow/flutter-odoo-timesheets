import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';

class CrudDataCubit<T, F extends OffsetLimitFilter, DF extends ByIdFilter>
    extends DataCubit<T, DF> {
  CrudDataCubit({required this.repository}) : super(repository.getItemById);

  final CrudRepository<T, F, DF> repository;

  Future<T?> createItem(T item) async {
    final updatedItem = await repository.createItem(item);

    if (updatedItem != null) {
      emit(
        state.copyWith(
          data: updatedItem,
        ),
      );
    }

    return updatedItem;
  }

  Future<void> updateItem(T item) async {
    await repository.updateItem(item);
    load();
  }

  Future<void> deleteItem(int id) async {
    await repository.deleteItem(id);
  }
}