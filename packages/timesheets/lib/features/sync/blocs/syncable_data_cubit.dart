import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:list_bloc/list_bloc.dart';

abstract class SyncableDataCubit<T extends SyncModel, F>
    extends DataCubit<T, F> {
  SyncableDataCubit(super.loader, this.repository);

  final SyncRepository<T> repository;

  Future<T?> createItem(T model) async {
    final createdModel = await repository.create(model);
    return createdModel;
  }

  Future<T> updateItem(T model) async {
    final updatedObject = await repository.update(model.copyWith(
      writeDate: DateTime.timestamp(),
    ) as T);
    update(updatedObject);
    return updatedObject;
  }

  Future<void> deleteItem(int id) async {
    await repository.delete(id);
  }
}
