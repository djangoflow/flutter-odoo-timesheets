import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:list_bloc/list_bloc.dart';

abstract class SyncableListCubit<T extends SyncModel, F>
    extends ListCubit<T, F> {
  SyncableListCubit(super.loader, this.repository);

  final SyncRepository<T> repository;

  Future<T?> createItem(T model) async {
    final createdModel = await repository.create(model);
    return createdModel;
  }

  Future<T> updateItem(T model, {bool shouldUpdateSecondaryOnly = false});

  Future<void> deleteItem(int id) async {
    await repository.delete(id);
  }
}
