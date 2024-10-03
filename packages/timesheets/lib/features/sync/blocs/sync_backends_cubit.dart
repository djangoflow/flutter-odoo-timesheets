import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/sync/sync.dart';

class SyncBackendCubit extends HydratedCubit<Map<String, Map<String, String>>> {
  final SyncBackendsRepository _repository;

  SyncBackendCubit(this._repository) : super({});

  // Get backend ID by type for a specific baseUrl
  String? getBackendId(String baseUrl, String type) => state[baseUrl]?[type];

  // Add or update a backend for a specific baseUrl
  Future<void> addOrUpdateBackend(
      String baseUrl, String type, String id) async {
    // Persist in local database
    final syncBackend = SyncBackend(id: id, type: type, baseUrl: baseUrl);
    final existingBackends = await _repository.fetchBackendsByBaseUrl(baseUrl);
    if (existingBackends.any((backend) => backend.id == id)) {
      // Do nothing if the backend already exists
      // await _repository.updateSyncBackend(syncBackend);
    } else {
      await _repository.insertSyncBackend(syncBackend);
    }

    final currentMap = state[baseUrl] ?? {};
    final updatedMap = {...currentMap, type: id};

    // Update the state
    emit({...state, baseUrl: updatedMap});
  }

  // Remove a backend by id and baseUrl
  Future<void> removeBackend(String baseUrl, String id) async {
    // Remove from the database
    await _repository.deleteSyncBackend(id, baseUrl);
    final currentMap = state[baseUrl] ?? {};
    final updatedMap = {...currentMap};
    updatedMap.removeWhere((key, value) => value == id);

    // Update the state
    emit({...state, baseUrl: updatedMap});
  }

  @override
  Map<String, Map<String, String>> fromJson(Map<String, dynamic> json) =>
      json.map((key, value) {
        if (value is Map) {
          return MapEntry(
            key,
            value.cast<String, String>(),
          );
        } else {
          // Handle unexpected value types
          return MapEntry(key, <String, String>{});
        }
      });

  @override
  Map<String, dynamic> toJson(Map<String, Map<String, String>> state) =>
      state.map((key, value) => MapEntry(key, value.cast<String, dynamic>()));
}
