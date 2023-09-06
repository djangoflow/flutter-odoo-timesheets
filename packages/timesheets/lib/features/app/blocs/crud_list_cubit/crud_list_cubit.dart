import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/app/app.dart';

class CrudListCubit<T, F extends OffsetLimitFilter> extends ListCubit<T, F> {
  CrudListCubit({required this.repository})
      : super(repository.getPaginatedItems);

  final CrudRepository<T, F> repository;

  Future<void> createItem(T item) async {
    final id = await repository.createItem(item);
    final updatedItem = await repository.getItemById(id);
    if (updatedItem != null) {
      emit(
        state.copyWith(
          data: [...state.data ?? [], updatedItem],
        ),
      );
    }
  }

  Future<void> updateItem(T item) async {
    await repository.updateItem(item);
    reload();
  }

  Future<void> deleteItem(int id) async {
    await repository.deleteItem(id);
    reload();
  }

  // later we can modify to use with DataBloc if needed
  Future<T?> getItemById(int id) async => await repository.getItemById(id);
}
