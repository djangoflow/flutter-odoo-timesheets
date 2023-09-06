import 'package:timesheets/features_refactored/app/data/data_source.dart';
import 'package:timesheets/features_refactored/app/data/repository.dart';
import 'package:timesheets/features_refactored/timesheet/data/entities/timesheet_entity.dart';

class TimesheetRepository implements Repository<TimesheetEntity> {
  final DataSource<TimesheetEntity> _dataSource;

  TimesheetRepository(this._dataSource);
  @override
  Future<int> delete(int id) => dataSource.delete(id);

  @override
  Future<List<TimesheetEntity>> getAll() => dataSource.getAll();

  @override
  Future<TimesheetEntity?> getById(int id) => dataSource.getById(id);

  @override
  Future<List<TimesheetEntity>> getPaginatedItems(
          {int? offset, int? limit, String? search}) =>
      dataSource.getPaginatedItems(
          offset: offset, limit: limit, search: search);

  @override
  Future<int> insert(TimesheetEntity entity) => dataSource.insert(entity);

  @override
  Future<bool> update(TimesheetEntity entity) => dataSource.update(entity);

  @override
  DataSource<TimesheetEntity> get dataSource => _dataSource;
}
