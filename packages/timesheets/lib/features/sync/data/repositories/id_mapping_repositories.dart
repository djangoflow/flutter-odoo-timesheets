import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:drift/drift.dart';

import '../database/database.dart';

class AppIdMappingRepository extends IdMappingRepository {
  final AppDatabase database;

  AppIdMappingRepository(this.database);

  @override
  Future<void> updateRelatedFields(
      String modelName, int oldId, int newId) async {
    switch (modelName) {
      case 'flight.aircraft':
        await _updateFlightsForAircraft(oldId, newId);
        break;
      case 'flight.aerodrome':
        await _updateFlightsForAerodrome(oldId, newId);
        break;
      // Add more cases for other entity types as needed
      default:
        throw UnimplementedError('ID mapping not implemented for $modelName');
    }
  }

  Future<void> _updateFlightsForAircraft(int oldId, int newId) async {
    await (database.update(database.flightFlights)
          ..where((t) => t.aircraftId.equals(oldId)))
        .write(FlightFlightsCompanion(aircraftId: Value(newId)));
  }

  Future<void> _updateFlightsForAerodrome(int oldId, int newId) async {
    await (database.update(database.flightFlights)
          ..where((t) => t.arrivalId.equals(oldId)))
        .write(FlightFlightsCompanion(arrivalId: Value(newId)));

    await (database.update(database.flightFlights)
          ..where((t) => t.departureId.equals(oldId)))
        .write(FlightFlightsCompanion(departureId: Value(newId)));
  }

  // You might want to add a method to handle batch updates for performance
  @override
  Future<void> batchUpdateRelatedFields(
      List<MapEntry<String, MapEntry<int, int>>> updates) async {
    await database.transaction(() async {
      for (var update in updates) {
        await updateRelatedFields(
            update.key, update.value.key, update.value.value);
      }
    });
  }
}
