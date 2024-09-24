// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:djangoflow_sync_drift_odoo/src/database/database.drift.dart'
    as i1;
import 'package:sync_foundation_test/features/sync/data/database/database.drift.dart'
    as i2;
import 'package:sync_foundation_test/features/sync/data/database/database.dart'
    as i3;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i4;
import 'package:drift/internal/modular.dart' as i5;

abstract class $AppDatabase extends i0.GeneratedDatabase {
  $AppDatabase(i0.QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final i1.$SyncBackendsTable syncBackends = i1.$SyncBackendsTable(this);
  late final i2.$FlightAircraftsTable flightAircrafts =
      i2.$FlightAircraftsTable(this);
  late final i2.$FlightAerodromesTable flightAerodromes =
      i2.$FlightAerodromesTable(this);
  late final i2.$FlightFlightsTable flightFlights =
      i2.$FlightFlightsTable(this);
  late final i1.$SyncRegistriesTable syncRegistries =
      i1.$SyncRegistriesTable(this);
  @override
  Iterable<i0.TableInfo<i0.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<i0.TableInfo<i0.Table, Object?>>();
  @override
  List<i0.DatabaseSchemaEntity> get allSchemaEntities => [
        syncBackends,
        flightAircrafts,
        flightAerodromes,
        flightFlights,
        syncRegistries
      ];
  @override
  i0.StreamQueryUpdateRules get streamUpdateRules =>
      const i0.StreamQueryUpdateRules(
        [
          i0.WritePropagation(
            on: i0.TableUpdateQuery.onTableName('sync_backends',
                limitUpdateKind: i0.UpdateKind.delete),
            result: [
              i0.TableUpdate('sync_registries', kind: i0.UpdateKind.delete),
            ],
          ),
        ],
      );
  @override
  i0.DriftDatabaseOptions get options =>
      const i0.DriftDatabaseOptions(storeDateTimeAsText: true);
}

class $AppDatabaseManager {
  final $AppDatabase _db;
  $AppDatabaseManager(this._db);
  i1.$$SyncBackendsTableTableManager get syncBackends =>
      i1.$$SyncBackendsTableTableManager(_db, _db.syncBackends);
  i2.$$FlightAircraftsTableTableManager get flightAircrafts =>
      i2.$$FlightAircraftsTableTableManager(_db, _db.flightAircrafts);
  i2.$$FlightAerodromesTableTableManager get flightAerodromes =>
      i2.$$FlightAerodromesTableTableManager(_db, _db.flightAerodromes);
  i2.$$FlightFlightsTableTableManager get flightFlights =>
      i2.$$FlightFlightsTableTableManager(_db, _db.flightFlights);
  i1.$$SyncRegistriesTableTableManager get syncRegistries =>
      i1.$$SyncRegistriesTableTableManager(_db, _db.syncRegistries);
}

class $FlightFlightsTable extends i3.FlightFlights
    with i0.TableInfo<$FlightFlightsTable, i2.FlightFlight> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightFlightsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const i0.VerificationMeta _createDateMeta =
      const i0.VerificationMeta('createDate');
  @override
  late final i0.GeneratedColumn<DateTime> createDate =
      i0.GeneratedColumn<DateTime>('create_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _writeDateMeta =
      const i0.VerificationMeta('writeDate');
  @override
  late final i0.GeneratedColumn<DateTime> writeDate =
      i0.GeneratedColumn<DateTime>('write_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _isMarkedAsDeletedMeta =
      const i0.VerificationMeta('isMarkedAsDeleted');
  @override
  late final i0.GeneratedColumn<bool> isMarkedAsDeleted =
      i0.GeneratedColumn<bool>('is_marked_as_deleted', aliasedName, false,
          type: i0.DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'CHECK ("is_marked_as_deleted" IN (0, 1))'),
          defaultValue: const i4.Constant(false));
  static const i0.VerificationMeta _backendIdMeta =
      const i0.VerificationMeta('backendId');
  @override
  late final i0.GeneratedColumn<String> backendId = i0.GeneratedColumn<String>(
      'backend_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_backends (id)'));
  static const i0.VerificationMeta _aircraftIdMeta =
      const i0.VerificationMeta('aircraftId');
  @override
  late final i0.GeneratedColumn<int> aircraftId = i0.GeneratedColumn<int>(
      'aircraft_id', aliasedName, false,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES flight_aircrafts (id) ON DELETE RESTRICT'));
  static const i0.VerificationMeta _arrivalIdMeta =
      const i0.VerificationMeta('arrivalId');
  @override
  late final i0.GeneratedColumn<int> arrivalId = i0.GeneratedColumn<int>(
      'arrival_id', aliasedName, false,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES flight_aerodromes (id) ON DELETE RESTRICT'));
  static const i0.VerificationMeta _departureIdMeta =
      const i0.VerificationMeta('departureId');
  @override
  late final i0.GeneratedColumn<int> departureId = i0.GeneratedColumn<int>(
      'departure_id', aliasedName, false,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES flight_aerodromes (id) ON DELETE RESTRICT'));
  static const i0.VerificationMeta _dateMeta =
      const i0.VerificationMeta('date');
  @override
  late final i0.GeneratedColumn<DateTime> date = i0.GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: i0.DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        createDate,
        writeDate,
        isMarkedAsDeleted,
        backendId,
        aircraftId,
        arrivalId,
        departureId,
        date
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flight_flights';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i2.FlightFlight> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    } else if (isInserting) {
      context.missing(_createDateMeta);
    }
    if (data.containsKey('write_date')) {
      context.handle(_writeDateMeta,
          writeDate.isAcceptableOrUnknown(data['write_date']!, _writeDateMeta));
    } else if (isInserting) {
      context.missing(_writeDateMeta);
    }
    if (data.containsKey('is_marked_as_deleted')) {
      context.handle(
          _isMarkedAsDeletedMeta,
          isMarkedAsDeleted.isAcceptableOrUnknown(
              data['is_marked_as_deleted']!, _isMarkedAsDeletedMeta));
    }
    if (data.containsKey('backend_id')) {
      context.handle(_backendIdMeta,
          backendId.isAcceptableOrUnknown(data['backend_id']!, _backendIdMeta));
    } else if (isInserting) {
      context.missing(_backendIdMeta);
    }
    if (data.containsKey('aircraft_id')) {
      context.handle(
          _aircraftIdMeta,
          aircraftId.isAcceptableOrUnknown(
              data['aircraft_id']!, _aircraftIdMeta));
    } else if (isInserting) {
      context.missing(_aircraftIdMeta);
    }
    if (data.containsKey('arrival_id')) {
      context.handle(_arrivalIdMeta,
          arrivalId.isAcceptableOrUnknown(data['arrival_id']!, _arrivalIdMeta));
    } else if (isInserting) {
      context.missing(_arrivalIdMeta);
    }
    if (data.containsKey('departure_id')) {
      context.handle(
          _departureIdMeta,
          departureId.isAcceptableOrUnknown(
              data['departure_id']!, _departureIdMeta));
    } else if (isInserting) {
      context.missing(_departureIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i2.FlightFlight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i2.FlightFlight(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}id'])!,
      createDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}create_date'])!,
      writeDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}write_date'])!,
      isMarkedAsDeleted: attachedDatabase.typeMapping.read(i0.DriftSqlType.bool,
          data['${effectivePrefix}is_marked_as_deleted'])!,
      backendId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}backend_id'])!,
      aircraftId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}aircraft_id'])!,
      arrivalId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}arrival_id'])!,
      departureId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}departure_id'])!,
      date: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}date']),
    );
  }

  @override
  $FlightFlightsTable createAlias(String alias) {
    return $FlightFlightsTable(attachedDatabase, alias);
  }
}

class FlightFlight extends i0.DataClass
    implements i0.Insertable<i2.FlightFlight> {
  final int id;
  final DateTime createDate;
  final DateTime writeDate;
  final bool isMarkedAsDeleted;
  final String backendId;
  final int aircraftId;
  final int arrivalId;
  final int departureId;
  final DateTime? date;
  const FlightFlight(
      {required this.id,
      required this.createDate,
      required this.writeDate,
      required this.isMarkedAsDeleted,
      required this.backendId,
      required this.aircraftId,
      required this.arrivalId,
      required this.departureId,
      this.date});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['create_date'] = i0.Variable<DateTime>(createDate);
    map['write_date'] = i0.Variable<DateTime>(writeDate);
    map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted);
    map['backend_id'] = i0.Variable<String>(backendId);
    map['aircraft_id'] = i0.Variable<int>(aircraftId);
    map['arrival_id'] = i0.Variable<int>(arrivalId);
    map['departure_id'] = i0.Variable<int>(departureId);
    if (!nullToAbsent || date != null) {
      map['date'] = i0.Variable<DateTime>(date);
    }
    return map;
  }

  i2.FlightFlightsCompanion toCompanion(bool nullToAbsent) {
    return i2.FlightFlightsCompanion(
      id: i0.Value(id),
      createDate: i0.Value(createDate),
      writeDate: i0.Value(writeDate),
      isMarkedAsDeleted: i0.Value(isMarkedAsDeleted),
      backendId: i0.Value(backendId),
      aircraftId: i0.Value(aircraftId),
      arrivalId: i0.Value(arrivalId),
      departureId: i0.Value(departureId),
      date: date == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(date),
    );
  }

  factory FlightFlight.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return FlightFlight(
      id: serializer.fromJson<int>(json['id']),
      createDate: serializer.fromJson<DateTime>(json['createDate']),
      writeDate: serializer.fromJson<DateTime>(json['writeDate']),
      isMarkedAsDeleted: serializer.fromJson<bool>(json['isMarkedAsDeleted']),
      backendId: serializer.fromJson<String>(json['backendId']),
      aircraftId: serializer.fromJson<int>(json['aircraftId']),
      arrivalId: serializer.fromJson<int>(json['arrivalId']),
      departureId: serializer.fromJson<int>(json['departureId']),
      date: serializer.fromJson<DateTime?>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createDate': serializer.toJson<DateTime>(createDate),
      'writeDate': serializer.toJson<DateTime>(writeDate),
      'isMarkedAsDeleted': serializer.toJson<bool>(isMarkedAsDeleted),
      'backendId': serializer.toJson<String>(backendId),
      'aircraftId': serializer.toJson<int>(aircraftId),
      'arrivalId': serializer.toJson<int>(arrivalId),
      'departureId': serializer.toJson<int>(departureId),
      'date': serializer.toJson<DateTime?>(date),
    };
  }

  i2.FlightFlight copyWith(
          {int? id,
          DateTime? createDate,
          DateTime? writeDate,
          bool? isMarkedAsDeleted,
          String? backendId,
          int? aircraftId,
          int? arrivalId,
          int? departureId,
          i0.Value<DateTime?> date = const i0.Value.absent()}) =>
      i2.FlightFlight(
        id: id ?? this.id,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
        backendId: backendId ?? this.backendId,
        aircraftId: aircraftId ?? this.aircraftId,
        arrivalId: arrivalId ?? this.arrivalId,
        departureId: departureId ?? this.departureId,
        date: date.present ? date.value : this.date,
      );
  FlightFlight copyWithCompanion(i2.FlightFlightsCompanion data) {
    return FlightFlight(
      id: data.id.present ? data.id.value : this.id,
      createDate:
          data.createDate.present ? data.createDate.value : this.createDate,
      writeDate: data.writeDate.present ? data.writeDate.value : this.writeDate,
      isMarkedAsDeleted: data.isMarkedAsDeleted.present
          ? data.isMarkedAsDeleted.value
          : this.isMarkedAsDeleted,
      backendId: data.backendId.present ? data.backendId.value : this.backendId,
      aircraftId:
          data.aircraftId.present ? data.aircraftId.value : this.aircraftId,
      arrivalId: data.arrivalId.present ? data.arrivalId.value : this.arrivalId,
      departureId:
          data.departureId.present ? data.departureId.value : this.departureId,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlightFlight(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('aircraftId: $aircraftId, ')
          ..write('arrivalId: $arrivalId, ')
          ..write('departureId: $departureId, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createDate, writeDate, isMarkedAsDeleted,
      backendId, aircraftId, arrivalId, departureId, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i2.FlightFlight &&
          other.id == this.id &&
          other.createDate == this.createDate &&
          other.writeDate == this.writeDate &&
          other.isMarkedAsDeleted == this.isMarkedAsDeleted &&
          other.backendId == this.backendId &&
          other.aircraftId == this.aircraftId &&
          other.arrivalId == this.arrivalId &&
          other.departureId == this.departureId &&
          other.date == this.date);
}

class FlightFlightsCompanion extends i0.UpdateCompanion<i2.FlightFlight> {
  final i0.Value<int> id;
  final i0.Value<DateTime> createDate;
  final i0.Value<DateTime> writeDate;
  final i0.Value<bool> isMarkedAsDeleted;
  final i0.Value<String> backendId;
  final i0.Value<int> aircraftId;
  final i0.Value<int> arrivalId;
  final i0.Value<int> departureId;
  final i0.Value<DateTime?> date;
  const FlightFlightsCompanion({
    this.id = const i0.Value.absent(),
    this.createDate = const i0.Value.absent(),
    this.writeDate = const i0.Value.absent(),
    this.isMarkedAsDeleted = const i0.Value.absent(),
    this.backendId = const i0.Value.absent(),
    this.aircraftId = const i0.Value.absent(),
    this.arrivalId = const i0.Value.absent(),
    this.departureId = const i0.Value.absent(),
    this.date = const i0.Value.absent(),
  });
  FlightFlightsCompanion.insert({
    this.id = const i0.Value.absent(),
    required DateTime createDate,
    required DateTime writeDate,
    this.isMarkedAsDeleted = const i0.Value.absent(),
    required String backendId,
    required int aircraftId,
    required int arrivalId,
    required int departureId,
    this.date = const i0.Value.absent(),
  })  : createDate = i0.Value(createDate),
        writeDate = i0.Value(writeDate),
        backendId = i0.Value(backendId),
        aircraftId = i0.Value(aircraftId),
        arrivalId = i0.Value(arrivalId),
        departureId = i0.Value(departureId);
  static i0.Insertable<i2.FlightFlight> custom({
    i0.Expression<int>? id,
    i0.Expression<DateTime>? createDate,
    i0.Expression<DateTime>? writeDate,
    i0.Expression<bool>? isMarkedAsDeleted,
    i0.Expression<String>? backendId,
    i0.Expression<int>? aircraftId,
    i0.Expression<int>? arrivalId,
    i0.Expression<int>? departureId,
    i0.Expression<DateTime>? date,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (createDate != null) 'create_date': createDate,
      if (writeDate != null) 'write_date': writeDate,
      if (isMarkedAsDeleted != null) 'is_marked_as_deleted': isMarkedAsDeleted,
      if (backendId != null) 'backend_id': backendId,
      if (aircraftId != null) 'aircraft_id': aircraftId,
      if (arrivalId != null) 'arrival_id': arrivalId,
      if (departureId != null) 'departure_id': departureId,
      if (date != null) 'date': date,
    });
  }

  i2.FlightFlightsCompanion copyWith(
      {i0.Value<int>? id,
      i0.Value<DateTime>? createDate,
      i0.Value<DateTime>? writeDate,
      i0.Value<bool>? isMarkedAsDeleted,
      i0.Value<String>? backendId,
      i0.Value<int>? aircraftId,
      i0.Value<int>? arrivalId,
      i0.Value<int>? departureId,
      i0.Value<DateTime?>? date}) {
    return i2.FlightFlightsCompanion(
      id: id ?? this.id,
      createDate: createDate ?? this.createDate,
      writeDate: writeDate ?? this.writeDate,
      isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
      backendId: backendId ?? this.backendId,
      aircraftId: aircraftId ?? this.aircraftId,
      arrivalId: arrivalId ?? this.arrivalId,
      departureId: departureId ?? this.departureId,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (createDate.present) {
      map['create_date'] = i0.Variable<DateTime>(createDate.value);
    }
    if (writeDate.present) {
      map['write_date'] = i0.Variable<DateTime>(writeDate.value);
    }
    if (isMarkedAsDeleted.present) {
      map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted.value);
    }
    if (backendId.present) {
      map['backend_id'] = i0.Variable<String>(backendId.value);
    }
    if (aircraftId.present) {
      map['aircraft_id'] = i0.Variable<int>(aircraftId.value);
    }
    if (arrivalId.present) {
      map['arrival_id'] = i0.Variable<int>(arrivalId.value);
    }
    if (departureId.present) {
      map['departure_id'] = i0.Variable<int>(departureId.value);
    }
    if (date.present) {
      map['date'] = i0.Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightFlightsCompanion(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('aircraftId: $aircraftId, ')
          ..write('arrivalId: $arrivalId, ')
          ..write('departureId: $departureId, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

typedef $$FlightFlightsTableCreateCompanionBuilder = i2.FlightFlightsCompanion
    Function({
  i0.Value<int> id,
  required DateTime createDate,
  required DateTime writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  required String backendId,
  required int aircraftId,
  required int arrivalId,
  required int departureId,
  i0.Value<DateTime?> date,
});
typedef $$FlightFlightsTableUpdateCompanionBuilder = i2.FlightFlightsCompanion
    Function({
  i0.Value<int> id,
  i0.Value<DateTime> createDate,
  i0.Value<DateTime> writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  i0.Value<String> backendId,
  i0.Value<int> aircraftId,
  i0.Value<int> arrivalId,
  i0.Value<int> departureId,
  i0.Value<DateTime?> date,
});

class $$FlightFlightsTableFilterComposer
    extends i0.FilterComposer<i0.GeneratedDatabase, i2.$FlightFlightsTable> {
  $$FlightFlightsTableFilterComposer(super.$state);
  i0.ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<DateTime> get createDate => $state.composableBuilder(
      column: $state.table.createDate,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<DateTime> get writeDate => $state.composableBuilder(
      column: $state.table.writeDate,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<bool> get isMarkedAsDeleted => $state.composableBuilder(
      column: $state.table.isMarkedAsDeleted,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i1.$$SyncBackendsTableFilterComposer get backendId {
    final i1.$$SyncBackendsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.backendId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i1.$SyncBackendsTable>('sync_backends'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i1.$$SyncBackendsTableFilterComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i1.$SyncBackendsTable>('sync_backends'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  i2.$$FlightAircraftsTableFilterComposer get aircraftId {
    final i2.$$FlightAircraftsTableFilterComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.aircraftId,
            referencedTable: i5.ReadDatabaseContainer($state
                    .db)
                .resultSet<i2.$FlightAircraftsTable>('flight_aircrafts'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    parentComposers) =>
                i2.$$FlightAircraftsTableFilterComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i2.$FlightAircraftsTable>('flight_aircrafts'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  i2.$$FlightAerodromesTableFilterComposer get arrivalId {
    final i2.$$FlightAerodromesTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.arrivalId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i2.$FlightAerodromesTable>('flight_aerodromes'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i2.$$FlightAerodromesTableFilterComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i2.$FlightAerodromesTable>(
                            'flight_aerodromes'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  i2.$$FlightAerodromesTableFilterComposer get departureId {
    final i2.$$FlightAerodromesTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.departureId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i2.$FlightAerodromesTable>('flight_aerodromes'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i2.$$FlightAerodromesTableFilterComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i2.$FlightAerodromesTable>(
                            'flight_aerodromes'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

class $$FlightFlightsTableOrderingComposer
    extends i0.OrderingComposer<i0.GeneratedDatabase, i2.$FlightFlightsTable> {
  $$FlightFlightsTableOrderingComposer(super.$state);
  i0.ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<DateTime> get createDate => $state.composableBuilder(
      column: $state.table.createDate,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<DateTime> get writeDate => $state.composableBuilder(
      column: $state.table.writeDate,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<bool> get isMarkedAsDeleted => $state.composableBuilder(
      column: $state.table.isMarkedAsDeleted,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i1.$$SyncBackendsTableOrderingComposer get backendId {
    final i1.$$SyncBackendsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.backendId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i1.$SyncBackendsTable>('sync_backends'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i1.$$SyncBackendsTableOrderingComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i1.$SyncBackendsTable>('sync_backends'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  i2.$$FlightAircraftsTableOrderingComposer get aircraftId {
    final i2.$$FlightAircraftsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.aircraftId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i2.$FlightAircraftsTable>('flight_aircrafts'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i2.$$FlightAircraftsTableOrderingComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i2.$FlightAircraftsTable>(
                            'flight_aircrafts'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  i2.$$FlightAerodromesTableOrderingComposer get arrivalId {
    final i2.$$FlightAerodromesTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.arrivalId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i2.$FlightAerodromesTable>('flight_aerodromes'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i2.$$FlightAerodromesTableOrderingComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i2.$FlightAerodromesTable>(
                            'flight_aerodromes'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  i2.$$FlightAerodromesTableOrderingComposer get departureId {
    final i2.$$FlightAerodromesTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.departureId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i2.$FlightAerodromesTable>('flight_aerodromes'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i2.$$FlightAerodromesTableOrderingComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i2.$FlightAerodromesTable>(
                            'flight_aerodromes'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

class $$FlightFlightsTableTableManager extends i0.RootTableManager<
    i0.GeneratedDatabase,
    i2.$FlightFlightsTable,
    i2.FlightFlight,
    i2.$$FlightFlightsTableFilterComposer,
    i2.$$FlightFlightsTableOrderingComposer,
    $$FlightFlightsTableCreateCompanionBuilder,
    $$FlightFlightsTableUpdateCompanionBuilder,
    (
      i2.FlightFlight,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$FlightFlightsTable,
          i2.FlightFlight>
    ),
    i2.FlightFlight,
    i0.PrefetchHooks Function(
        {bool backendId, bool aircraftId, bool arrivalId, bool departureId})> {
  $$FlightFlightsTableTableManager(
      i0.GeneratedDatabase db, i2.$FlightFlightsTable table)
      : super(i0.TableManagerState(
          db: db,
          table: table,
          filteringComposer: i2
              .$$FlightFlightsTableFilterComposer(i0.ComposerState(db, table)),
          orderingComposer: i2.$$FlightFlightsTableOrderingComposer(
              i0.ComposerState(db, table)),
          updateCompanionCallback: ({
            i0.Value<int> id = const i0.Value.absent(),
            i0.Value<DateTime> createDate = const i0.Value.absent(),
            i0.Value<DateTime> writeDate = const i0.Value.absent(),
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            i0.Value<String> backendId = const i0.Value.absent(),
            i0.Value<int> aircraftId = const i0.Value.absent(),
            i0.Value<int> arrivalId = const i0.Value.absent(),
            i0.Value<int> departureId = const i0.Value.absent(),
            i0.Value<DateTime?> date = const i0.Value.absent(),
          }) =>
              i2.FlightFlightsCompanion(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            aircraftId: aircraftId,
            arrivalId: arrivalId,
            departureId: departureId,
            date: date,
          ),
          createCompanionCallback: ({
            i0.Value<int> id = const i0.Value.absent(),
            required DateTime createDate,
            required DateTime writeDate,
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            required String backendId,
            required int aircraftId,
            required int arrivalId,
            required int departureId,
            i0.Value<DateTime?> date = const i0.Value.absent(),
          }) =>
              i2.FlightFlightsCompanion.insert(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            aircraftId: aircraftId,
            arrivalId: arrivalId,
            departureId: departureId,
            date: date,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FlightFlightsTableProcessedTableManager = i0.ProcessedTableManager<
    i0.GeneratedDatabase,
    i2.$FlightFlightsTable,
    i2.FlightFlight,
    i2.$$FlightFlightsTableFilterComposer,
    i2.$$FlightFlightsTableOrderingComposer,
    $$FlightFlightsTableCreateCompanionBuilder,
    $$FlightFlightsTableUpdateCompanionBuilder,
    (
      i2.FlightFlight,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$FlightFlightsTable,
          i2.FlightFlight>
    ),
    i2.FlightFlight,
    i0.PrefetchHooks Function(
        {bool backendId, bool aircraftId, bool arrivalId, bool departureId})>;

class $FlightAircraftsTable extends i3.FlightAircrafts
    with i0.TableInfo<$FlightAircraftsTable, i2.FlightAircraft> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightAircraftsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const i0.VerificationMeta _createDateMeta =
      const i0.VerificationMeta('createDate');
  @override
  late final i0.GeneratedColumn<DateTime> createDate =
      i0.GeneratedColumn<DateTime>('create_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _writeDateMeta =
      const i0.VerificationMeta('writeDate');
  @override
  late final i0.GeneratedColumn<DateTime> writeDate =
      i0.GeneratedColumn<DateTime>('write_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _isMarkedAsDeletedMeta =
      const i0.VerificationMeta('isMarkedAsDeleted');
  @override
  late final i0.GeneratedColumn<bool> isMarkedAsDeleted =
      i0.GeneratedColumn<bool>('is_marked_as_deleted', aliasedName, false,
          type: i0.DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'CHECK ("is_marked_as_deleted" IN (0, 1))'),
          defaultValue: const i4.Constant(false));
  static const i0.VerificationMeta _backendIdMeta =
      const i0.VerificationMeta('backendId');
  @override
  late final i0.GeneratedColumn<String> backendId = i0.GeneratedColumn<String>(
      'backend_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_backends (id)'));
  static const i0.VerificationMeta _registrationMeta =
      const i0.VerificationMeta('registration');
  @override
  late final i0.GeneratedColumn<String> registration =
      i0.GeneratedColumn<String>('registration', aliasedName, true,
          type: i0.DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<i0.GeneratedColumn> get $columns =>
      [id, createDate, writeDate, isMarkedAsDeleted, backendId, registration];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flight_aircrafts';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i2.FlightAircraft> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    } else if (isInserting) {
      context.missing(_createDateMeta);
    }
    if (data.containsKey('write_date')) {
      context.handle(_writeDateMeta,
          writeDate.isAcceptableOrUnknown(data['write_date']!, _writeDateMeta));
    } else if (isInserting) {
      context.missing(_writeDateMeta);
    }
    if (data.containsKey('is_marked_as_deleted')) {
      context.handle(
          _isMarkedAsDeletedMeta,
          isMarkedAsDeleted.isAcceptableOrUnknown(
              data['is_marked_as_deleted']!, _isMarkedAsDeletedMeta));
    }
    if (data.containsKey('backend_id')) {
      context.handle(_backendIdMeta,
          backendId.isAcceptableOrUnknown(data['backend_id']!, _backendIdMeta));
    } else if (isInserting) {
      context.missing(_backendIdMeta);
    }
    if (data.containsKey('registration')) {
      context.handle(
          _registrationMeta,
          registration.isAcceptableOrUnknown(
              data['registration']!, _registrationMeta));
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i2.FlightAircraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i2.FlightAircraft(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}id'])!,
      createDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}create_date'])!,
      writeDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}write_date'])!,
      isMarkedAsDeleted: attachedDatabase.typeMapping.read(i0.DriftSqlType.bool,
          data['${effectivePrefix}is_marked_as_deleted'])!,
      backendId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}backend_id'])!,
      registration: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}registration']),
    );
  }

  @override
  $FlightAircraftsTable createAlias(String alias) {
    return $FlightAircraftsTable(attachedDatabase, alias);
  }
}

class FlightAircraft extends i0.DataClass
    implements i0.Insertable<i2.FlightAircraft> {
  final int id;
  final DateTime createDate;
  final DateTime writeDate;
  final bool isMarkedAsDeleted;
  final String backendId;
  final String? registration;
  const FlightAircraft(
      {required this.id,
      required this.createDate,
      required this.writeDate,
      required this.isMarkedAsDeleted,
      required this.backendId,
      this.registration});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['create_date'] = i0.Variable<DateTime>(createDate);
    map['write_date'] = i0.Variable<DateTime>(writeDate);
    map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted);
    map['backend_id'] = i0.Variable<String>(backendId);
    if (!nullToAbsent || registration != null) {
      map['registration'] = i0.Variable<String>(registration);
    }
    return map;
  }

  i2.FlightAircraftsCompanion toCompanion(bool nullToAbsent) {
    return i2.FlightAircraftsCompanion(
      id: i0.Value(id),
      createDate: i0.Value(createDate),
      writeDate: i0.Value(writeDate),
      isMarkedAsDeleted: i0.Value(isMarkedAsDeleted),
      backendId: i0.Value(backendId),
      registration: registration == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(registration),
    );
  }

  factory FlightAircraft.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return FlightAircraft(
      id: serializer.fromJson<int>(json['id']),
      createDate: serializer.fromJson<DateTime>(json['createDate']),
      writeDate: serializer.fromJson<DateTime>(json['writeDate']),
      isMarkedAsDeleted: serializer.fromJson<bool>(json['isMarkedAsDeleted']),
      backendId: serializer.fromJson<String>(json['backendId']),
      registration: serializer.fromJson<String?>(json['registration']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createDate': serializer.toJson<DateTime>(createDate),
      'writeDate': serializer.toJson<DateTime>(writeDate),
      'isMarkedAsDeleted': serializer.toJson<bool>(isMarkedAsDeleted),
      'backendId': serializer.toJson<String>(backendId),
      'registration': serializer.toJson<String?>(registration),
    };
  }

  i2.FlightAircraft copyWith(
          {int? id,
          DateTime? createDate,
          DateTime? writeDate,
          bool? isMarkedAsDeleted,
          String? backendId,
          i0.Value<String?> registration = const i0.Value.absent()}) =>
      i2.FlightAircraft(
        id: id ?? this.id,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
        backendId: backendId ?? this.backendId,
        registration:
            registration.present ? registration.value : this.registration,
      );
  FlightAircraft copyWithCompanion(i2.FlightAircraftsCompanion data) {
    return FlightAircraft(
      id: data.id.present ? data.id.value : this.id,
      createDate:
          data.createDate.present ? data.createDate.value : this.createDate,
      writeDate: data.writeDate.present ? data.writeDate.value : this.writeDate,
      isMarkedAsDeleted: data.isMarkedAsDeleted.present
          ? data.isMarkedAsDeleted.value
          : this.isMarkedAsDeleted,
      backendId: data.backendId.present ? data.backendId.value : this.backendId,
      registration: data.registration.present
          ? data.registration.value
          : this.registration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlightAircraft(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('registration: $registration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, createDate, writeDate, isMarkedAsDeleted, backendId, registration);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i2.FlightAircraft &&
          other.id == this.id &&
          other.createDate == this.createDate &&
          other.writeDate == this.writeDate &&
          other.isMarkedAsDeleted == this.isMarkedAsDeleted &&
          other.backendId == this.backendId &&
          other.registration == this.registration);
}

class FlightAircraftsCompanion extends i0.UpdateCompanion<i2.FlightAircraft> {
  final i0.Value<int> id;
  final i0.Value<DateTime> createDate;
  final i0.Value<DateTime> writeDate;
  final i0.Value<bool> isMarkedAsDeleted;
  final i0.Value<String> backendId;
  final i0.Value<String?> registration;
  const FlightAircraftsCompanion({
    this.id = const i0.Value.absent(),
    this.createDate = const i0.Value.absent(),
    this.writeDate = const i0.Value.absent(),
    this.isMarkedAsDeleted = const i0.Value.absent(),
    this.backendId = const i0.Value.absent(),
    this.registration = const i0.Value.absent(),
  });
  FlightAircraftsCompanion.insert({
    this.id = const i0.Value.absent(),
    required DateTime createDate,
    required DateTime writeDate,
    this.isMarkedAsDeleted = const i0.Value.absent(),
    required String backendId,
    this.registration = const i0.Value.absent(),
  })  : createDate = i0.Value(createDate),
        writeDate = i0.Value(writeDate),
        backendId = i0.Value(backendId);
  static i0.Insertable<i2.FlightAircraft> custom({
    i0.Expression<int>? id,
    i0.Expression<DateTime>? createDate,
    i0.Expression<DateTime>? writeDate,
    i0.Expression<bool>? isMarkedAsDeleted,
    i0.Expression<String>? backendId,
    i0.Expression<String>? registration,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (createDate != null) 'create_date': createDate,
      if (writeDate != null) 'write_date': writeDate,
      if (isMarkedAsDeleted != null) 'is_marked_as_deleted': isMarkedAsDeleted,
      if (backendId != null) 'backend_id': backendId,
      if (registration != null) 'registration': registration,
    });
  }

  i2.FlightAircraftsCompanion copyWith(
      {i0.Value<int>? id,
      i0.Value<DateTime>? createDate,
      i0.Value<DateTime>? writeDate,
      i0.Value<bool>? isMarkedAsDeleted,
      i0.Value<String>? backendId,
      i0.Value<String?>? registration}) {
    return i2.FlightAircraftsCompanion(
      id: id ?? this.id,
      createDate: createDate ?? this.createDate,
      writeDate: writeDate ?? this.writeDate,
      isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
      backendId: backendId ?? this.backendId,
      registration: registration ?? this.registration,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (createDate.present) {
      map['create_date'] = i0.Variable<DateTime>(createDate.value);
    }
    if (writeDate.present) {
      map['write_date'] = i0.Variable<DateTime>(writeDate.value);
    }
    if (isMarkedAsDeleted.present) {
      map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted.value);
    }
    if (backendId.present) {
      map['backend_id'] = i0.Variable<String>(backendId.value);
    }
    if (registration.present) {
      map['registration'] = i0.Variable<String>(registration.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightAircraftsCompanion(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('registration: $registration')
          ..write(')'))
        .toString();
  }
}

typedef $$FlightAircraftsTableCreateCompanionBuilder
    = i2.FlightAircraftsCompanion Function({
  i0.Value<int> id,
  required DateTime createDate,
  required DateTime writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  required String backendId,
  i0.Value<String?> registration,
});
typedef $$FlightAircraftsTableUpdateCompanionBuilder
    = i2.FlightAircraftsCompanion Function({
  i0.Value<int> id,
  i0.Value<DateTime> createDate,
  i0.Value<DateTime> writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  i0.Value<String> backendId,
  i0.Value<String?> registration,
});

class $$FlightAircraftsTableFilterComposer
    extends i0.FilterComposer<i0.GeneratedDatabase, i2.$FlightAircraftsTable> {
  $$FlightAircraftsTableFilterComposer(super.$state);
  i0.ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<DateTime> get createDate => $state.composableBuilder(
      column: $state.table.createDate,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<DateTime> get writeDate => $state.composableBuilder(
      column: $state.table.writeDate,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<bool> get isMarkedAsDeleted => $state.composableBuilder(
      column: $state.table.isMarkedAsDeleted,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<String> get registration => $state.composableBuilder(
      column: $state.table.registration,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i1.$$SyncBackendsTableFilterComposer get backendId {
    final i1.$$SyncBackendsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.backendId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i1.$SyncBackendsTable>('sync_backends'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i1.$$SyncBackendsTableFilterComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i1.$SyncBackendsTable>('sync_backends'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

class $$FlightAircraftsTableOrderingComposer extends i0
    .OrderingComposer<i0.GeneratedDatabase, i2.$FlightAircraftsTable> {
  $$FlightAircraftsTableOrderingComposer(super.$state);
  i0.ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<DateTime> get createDate => $state.composableBuilder(
      column: $state.table.createDate,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<DateTime> get writeDate => $state.composableBuilder(
      column: $state.table.writeDate,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<bool> get isMarkedAsDeleted => $state.composableBuilder(
      column: $state.table.isMarkedAsDeleted,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<String> get registration => $state.composableBuilder(
      column: $state.table.registration,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i1.$$SyncBackendsTableOrderingComposer get backendId {
    final i1.$$SyncBackendsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.backendId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i1.$SyncBackendsTable>('sync_backends'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i1.$$SyncBackendsTableOrderingComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i1.$SyncBackendsTable>('sync_backends'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

class $$FlightAircraftsTableTableManager extends i0.RootTableManager<
    i0.GeneratedDatabase,
    i2.$FlightAircraftsTable,
    i2.FlightAircraft,
    i2.$$FlightAircraftsTableFilterComposer,
    i2.$$FlightAircraftsTableOrderingComposer,
    $$FlightAircraftsTableCreateCompanionBuilder,
    $$FlightAircraftsTableUpdateCompanionBuilder,
    (
      i2.FlightAircraft,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$FlightAircraftsTable,
          i2.FlightAircraft>
    ),
    i2.FlightAircraft,
    i0.PrefetchHooks Function({bool backendId})> {
  $$FlightAircraftsTableTableManager(
      i0.GeneratedDatabase db, i2.$FlightAircraftsTable table)
      : super(i0.TableManagerState(
          db: db,
          table: table,
          filteringComposer: i2.$$FlightAircraftsTableFilterComposer(
              i0.ComposerState(db, table)),
          orderingComposer: i2.$$FlightAircraftsTableOrderingComposer(
              i0.ComposerState(db, table)),
          updateCompanionCallback: ({
            i0.Value<int> id = const i0.Value.absent(),
            i0.Value<DateTime> createDate = const i0.Value.absent(),
            i0.Value<DateTime> writeDate = const i0.Value.absent(),
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            i0.Value<String> backendId = const i0.Value.absent(),
            i0.Value<String?> registration = const i0.Value.absent(),
          }) =>
              i2.FlightAircraftsCompanion(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            registration: registration,
          ),
          createCompanionCallback: ({
            i0.Value<int> id = const i0.Value.absent(),
            required DateTime createDate,
            required DateTime writeDate,
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            required String backendId,
            i0.Value<String?> registration = const i0.Value.absent(),
          }) =>
              i2.FlightAircraftsCompanion.insert(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            registration: registration,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FlightAircraftsTableProcessedTableManager = i0.ProcessedTableManager<
    i0.GeneratedDatabase,
    i2.$FlightAircraftsTable,
    i2.FlightAircraft,
    i2.$$FlightAircraftsTableFilterComposer,
    i2.$$FlightAircraftsTableOrderingComposer,
    $$FlightAircraftsTableCreateCompanionBuilder,
    $$FlightAircraftsTableUpdateCompanionBuilder,
    (
      i2.FlightAircraft,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$FlightAircraftsTable,
          i2.FlightAircraft>
    ),
    i2.FlightAircraft,
    i0.PrefetchHooks Function({bool backendId})>;

class $FlightAerodromesTable extends i3.FlightAerodromes
    with i0.TableInfo<$FlightAerodromesTable, i2.FlightAerodrome> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightAerodromesTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const i0.VerificationMeta _createDateMeta =
      const i0.VerificationMeta('createDate');
  @override
  late final i0.GeneratedColumn<DateTime> createDate =
      i0.GeneratedColumn<DateTime>('create_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _writeDateMeta =
      const i0.VerificationMeta('writeDate');
  @override
  late final i0.GeneratedColumn<DateTime> writeDate =
      i0.GeneratedColumn<DateTime>('write_date', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _isMarkedAsDeletedMeta =
      const i0.VerificationMeta('isMarkedAsDeleted');
  @override
  late final i0.GeneratedColumn<bool> isMarkedAsDeleted =
      i0.GeneratedColumn<bool>('is_marked_as_deleted', aliasedName, false,
          type: i0.DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'CHECK ("is_marked_as_deleted" IN (0, 1))'),
          defaultValue: const i4.Constant(false));
  static const i0.VerificationMeta _backendIdMeta =
      const i0.VerificationMeta('backendId');
  @override
  late final i0.GeneratedColumn<String> backendId = i0.GeneratedColumn<String>(
      'backend_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_backends (id)'));
  static const i0.VerificationMeta _nameMeta =
      const i0.VerificationMeta('name');
  @override
  late final i0.GeneratedColumn<String> name = i0.GeneratedColumn<String>(
      'name', aliasedName, true,
      type: i0.DriftSqlType.string, requiredDuringInsert: false);
  static const i0.VerificationMeta _icaoMeta =
      const i0.VerificationMeta('icao');
  @override
  late final i0.GeneratedColumn<String> icao = i0.GeneratedColumn<String>(
      'icao', aliasedName, true,
      type: i0.DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<i0.GeneratedColumn> get $columns =>
      [id, createDate, writeDate, isMarkedAsDeleted, backendId, name, icao];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flight_aerodromes';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i2.FlightAerodrome> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    } else if (isInserting) {
      context.missing(_createDateMeta);
    }
    if (data.containsKey('write_date')) {
      context.handle(_writeDateMeta,
          writeDate.isAcceptableOrUnknown(data['write_date']!, _writeDateMeta));
    } else if (isInserting) {
      context.missing(_writeDateMeta);
    }
    if (data.containsKey('is_marked_as_deleted')) {
      context.handle(
          _isMarkedAsDeletedMeta,
          isMarkedAsDeleted.isAcceptableOrUnknown(
              data['is_marked_as_deleted']!, _isMarkedAsDeletedMeta));
    }
    if (data.containsKey('backend_id')) {
      context.handle(_backendIdMeta,
          backendId.isAcceptableOrUnknown(data['backend_id']!, _backendIdMeta));
    } else if (isInserting) {
      context.missing(_backendIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('icao')) {
      context.handle(
          _icaoMeta, icao.isAcceptableOrUnknown(data['icao']!, _icaoMeta));
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i2.FlightAerodrome map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i2.FlightAerodrome(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}id'])!,
      createDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}create_date'])!,
      writeDate: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}write_date'])!,
      isMarkedAsDeleted: attachedDatabase.typeMapping.read(i0.DriftSqlType.bool,
          data['${effectivePrefix}is_marked_as_deleted'])!,
      backendId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}backend_id'])!,
      name: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}name']),
      icao: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}icao']),
    );
  }

  @override
  $FlightAerodromesTable createAlias(String alias) {
    return $FlightAerodromesTable(attachedDatabase, alias);
  }
}

class FlightAerodrome extends i0.DataClass
    implements i0.Insertable<i2.FlightAerodrome> {
  final int id;
  final DateTime createDate;
  final DateTime writeDate;
  final bool isMarkedAsDeleted;
  final String backendId;
  final String? name;
  final String? icao;
  const FlightAerodrome(
      {required this.id,
      required this.createDate,
      required this.writeDate,
      required this.isMarkedAsDeleted,
      required this.backendId,
      this.name,
      this.icao});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['create_date'] = i0.Variable<DateTime>(createDate);
    map['write_date'] = i0.Variable<DateTime>(writeDate);
    map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted);
    map['backend_id'] = i0.Variable<String>(backendId);
    if (!nullToAbsent || name != null) {
      map['name'] = i0.Variable<String>(name);
    }
    if (!nullToAbsent || icao != null) {
      map['icao'] = i0.Variable<String>(icao);
    }
    return map;
  }

  i2.FlightAerodromesCompanion toCompanion(bool nullToAbsent) {
    return i2.FlightAerodromesCompanion(
      id: i0.Value(id),
      createDate: i0.Value(createDate),
      writeDate: i0.Value(writeDate),
      isMarkedAsDeleted: i0.Value(isMarkedAsDeleted),
      backendId: i0.Value(backendId),
      name: name == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(name),
      icao: icao == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(icao),
    );
  }

  factory FlightAerodrome.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return FlightAerodrome(
      id: serializer.fromJson<int>(json['id']),
      createDate: serializer.fromJson<DateTime>(json['createDate']),
      writeDate: serializer.fromJson<DateTime>(json['writeDate']),
      isMarkedAsDeleted: serializer.fromJson<bool>(json['isMarkedAsDeleted']),
      backendId: serializer.fromJson<String>(json['backendId']),
      name: serializer.fromJson<String?>(json['name']),
      icao: serializer.fromJson<String?>(json['icao']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createDate': serializer.toJson<DateTime>(createDate),
      'writeDate': serializer.toJson<DateTime>(writeDate),
      'isMarkedAsDeleted': serializer.toJson<bool>(isMarkedAsDeleted),
      'backendId': serializer.toJson<String>(backendId),
      'name': serializer.toJson<String?>(name),
      'icao': serializer.toJson<String?>(icao),
    };
  }

  i2.FlightAerodrome copyWith(
          {int? id,
          DateTime? createDate,
          DateTime? writeDate,
          bool? isMarkedAsDeleted,
          String? backendId,
          i0.Value<String?> name = const i0.Value.absent(),
          i0.Value<String?> icao = const i0.Value.absent()}) =>
      i2.FlightAerodrome(
        id: id ?? this.id,
        createDate: createDate ?? this.createDate,
        writeDate: writeDate ?? this.writeDate,
        isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
        backendId: backendId ?? this.backendId,
        name: name.present ? name.value : this.name,
        icao: icao.present ? icao.value : this.icao,
      );
  FlightAerodrome copyWithCompanion(i2.FlightAerodromesCompanion data) {
    return FlightAerodrome(
      id: data.id.present ? data.id.value : this.id,
      createDate:
          data.createDate.present ? data.createDate.value : this.createDate,
      writeDate: data.writeDate.present ? data.writeDate.value : this.writeDate,
      isMarkedAsDeleted: data.isMarkedAsDeleted.present
          ? data.isMarkedAsDeleted.value
          : this.isMarkedAsDeleted,
      backendId: data.backendId.present ? data.backendId.value : this.backendId,
      name: data.name.present ? data.name.value : this.name,
      icao: data.icao.present ? data.icao.value : this.icao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlightAerodrome(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('name: $name, ')
          ..write('icao: $icao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, createDate, writeDate, isMarkedAsDeleted, backendId, name, icao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i2.FlightAerodrome &&
          other.id == this.id &&
          other.createDate == this.createDate &&
          other.writeDate == this.writeDate &&
          other.isMarkedAsDeleted == this.isMarkedAsDeleted &&
          other.backendId == this.backendId &&
          other.name == this.name &&
          other.icao == this.icao);
}

class FlightAerodromesCompanion extends i0.UpdateCompanion<i2.FlightAerodrome> {
  final i0.Value<int> id;
  final i0.Value<DateTime> createDate;
  final i0.Value<DateTime> writeDate;
  final i0.Value<bool> isMarkedAsDeleted;
  final i0.Value<String> backendId;
  final i0.Value<String?> name;
  final i0.Value<String?> icao;
  const FlightAerodromesCompanion({
    this.id = const i0.Value.absent(),
    this.createDate = const i0.Value.absent(),
    this.writeDate = const i0.Value.absent(),
    this.isMarkedAsDeleted = const i0.Value.absent(),
    this.backendId = const i0.Value.absent(),
    this.name = const i0.Value.absent(),
    this.icao = const i0.Value.absent(),
  });
  FlightAerodromesCompanion.insert({
    this.id = const i0.Value.absent(),
    required DateTime createDate,
    required DateTime writeDate,
    this.isMarkedAsDeleted = const i0.Value.absent(),
    required String backendId,
    this.name = const i0.Value.absent(),
    this.icao = const i0.Value.absent(),
  })  : createDate = i0.Value(createDate),
        writeDate = i0.Value(writeDate),
        backendId = i0.Value(backendId);
  static i0.Insertable<i2.FlightAerodrome> custom({
    i0.Expression<int>? id,
    i0.Expression<DateTime>? createDate,
    i0.Expression<DateTime>? writeDate,
    i0.Expression<bool>? isMarkedAsDeleted,
    i0.Expression<String>? backendId,
    i0.Expression<String>? name,
    i0.Expression<String>? icao,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (createDate != null) 'create_date': createDate,
      if (writeDate != null) 'write_date': writeDate,
      if (isMarkedAsDeleted != null) 'is_marked_as_deleted': isMarkedAsDeleted,
      if (backendId != null) 'backend_id': backendId,
      if (name != null) 'name': name,
      if (icao != null) 'icao': icao,
    });
  }

  i2.FlightAerodromesCompanion copyWith(
      {i0.Value<int>? id,
      i0.Value<DateTime>? createDate,
      i0.Value<DateTime>? writeDate,
      i0.Value<bool>? isMarkedAsDeleted,
      i0.Value<String>? backendId,
      i0.Value<String?>? name,
      i0.Value<String?>? icao}) {
    return i2.FlightAerodromesCompanion(
      id: id ?? this.id,
      createDate: createDate ?? this.createDate,
      writeDate: writeDate ?? this.writeDate,
      isMarkedAsDeleted: isMarkedAsDeleted ?? this.isMarkedAsDeleted,
      backendId: backendId ?? this.backendId,
      name: name ?? this.name,
      icao: icao ?? this.icao,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (createDate.present) {
      map['create_date'] = i0.Variable<DateTime>(createDate.value);
    }
    if (writeDate.present) {
      map['write_date'] = i0.Variable<DateTime>(writeDate.value);
    }
    if (isMarkedAsDeleted.present) {
      map['is_marked_as_deleted'] = i0.Variable<bool>(isMarkedAsDeleted.value);
    }
    if (backendId.present) {
      map['backend_id'] = i0.Variable<String>(backendId.value);
    }
    if (name.present) {
      map['name'] = i0.Variable<String>(name.value);
    }
    if (icao.present) {
      map['icao'] = i0.Variable<String>(icao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightAerodromesCompanion(')
          ..write('id: $id, ')
          ..write('createDate: $createDate, ')
          ..write('writeDate: $writeDate, ')
          ..write('isMarkedAsDeleted: $isMarkedAsDeleted, ')
          ..write('backendId: $backendId, ')
          ..write('name: $name, ')
          ..write('icao: $icao')
          ..write(')'))
        .toString();
  }
}

typedef $$FlightAerodromesTableCreateCompanionBuilder
    = i2.FlightAerodromesCompanion Function({
  i0.Value<int> id,
  required DateTime createDate,
  required DateTime writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  required String backendId,
  i0.Value<String?> name,
  i0.Value<String?> icao,
});
typedef $$FlightAerodromesTableUpdateCompanionBuilder
    = i2.FlightAerodromesCompanion Function({
  i0.Value<int> id,
  i0.Value<DateTime> createDate,
  i0.Value<DateTime> writeDate,
  i0.Value<bool> isMarkedAsDeleted,
  i0.Value<String> backendId,
  i0.Value<String?> name,
  i0.Value<String?> icao,
});

class $$FlightAerodromesTableFilterComposer
    extends i0.FilterComposer<i0.GeneratedDatabase, i2.$FlightAerodromesTable> {
  $$FlightAerodromesTableFilterComposer(super.$state);
  i0.ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<DateTime> get createDate => $state.composableBuilder(
      column: $state.table.createDate,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<DateTime> get writeDate => $state.composableBuilder(
      column: $state.table.writeDate,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<bool> get isMarkedAsDeleted => $state.composableBuilder(
      column: $state.table.isMarkedAsDeleted,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i0.ColumnFilters<String> get icao => $state.composableBuilder(
      column: $state.table.icao,
      builder: (column, joinBuilders) =>
          i0.ColumnFilters(column, joinBuilders: joinBuilders));

  i1.$$SyncBackendsTableFilterComposer get backendId {
    final i1.$$SyncBackendsTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.backendId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i1.$SyncBackendsTable>('sync_backends'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i1.$$SyncBackendsTableFilterComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i1.$SyncBackendsTable>('sync_backends'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

class $$FlightAerodromesTableOrderingComposer extends i0
    .OrderingComposer<i0.GeneratedDatabase, i2.$FlightAerodromesTable> {
  $$FlightAerodromesTableOrderingComposer(super.$state);
  i0.ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<DateTime> get createDate => $state.composableBuilder(
      column: $state.table.createDate,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<DateTime> get writeDate => $state.composableBuilder(
      column: $state.table.writeDate,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<bool> get isMarkedAsDeleted => $state.composableBuilder(
      column: $state.table.isMarkedAsDeleted,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i0.ColumnOrderings<String> get icao => $state.composableBuilder(
      column: $state.table.icao,
      builder: (column, joinBuilders) =>
          i0.ColumnOrderings(column, joinBuilders: joinBuilders));

  i1.$$SyncBackendsTableOrderingComposer get backendId {
    final i1.$$SyncBackendsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.backendId,
            referencedTable: i5.ReadDatabaseContainer($state.db)
                .resultSet<i1.$SyncBackendsTable>('sync_backends'),
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                i1.$$SyncBackendsTableOrderingComposer(i0.ComposerState(
                    $state.db,
                    i5.ReadDatabaseContainer($state.db)
                        .resultSet<i1.$SyncBackendsTable>('sync_backends'),
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

class $$FlightAerodromesTableTableManager extends i0.RootTableManager<
    i0.GeneratedDatabase,
    i2.$FlightAerodromesTable,
    i2.FlightAerodrome,
    i2.$$FlightAerodromesTableFilterComposer,
    i2.$$FlightAerodromesTableOrderingComposer,
    $$FlightAerodromesTableCreateCompanionBuilder,
    $$FlightAerodromesTableUpdateCompanionBuilder,
    (
      i2.FlightAerodrome,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$FlightAerodromesTable,
          i2.FlightAerodrome>
    ),
    i2.FlightAerodrome,
    i0.PrefetchHooks Function({bool backendId})> {
  $$FlightAerodromesTableTableManager(
      i0.GeneratedDatabase db, i2.$FlightAerodromesTable table)
      : super(i0.TableManagerState(
          db: db,
          table: table,
          filteringComposer: i2.$$FlightAerodromesTableFilterComposer(
              i0.ComposerState(db, table)),
          orderingComposer: i2.$$FlightAerodromesTableOrderingComposer(
              i0.ComposerState(db, table)),
          updateCompanionCallback: ({
            i0.Value<int> id = const i0.Value.absent(),
            i0.Value<DateTime> createDate = const i0.Value.absent(),
            i0.Value<DateTime> writeDate = const i0.Value.absent(),
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            i0.Value<String> backendId = const i0.Value.absent(),
            i0.Value<String?> name = const i0.Value.absent(),
            i0.Value<String?> icao = const i0.Value.absent(),
          }) =>
              i2.FlightAerodromesCompanion(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            name: name,
            icao: icao,
          ),
          createCompanionCallback: ({
            i0.Value<int> id = const i0.Value.absent(),
            required DateTime createDate,
            required DateTime writeDate,
            i0.Value<bool> isMarkedAsDeleted = const i0.Value.absent(),
            required String backendId,
            i0.Value<String?> name = const i0.Value.absent(),
            i0.Value<String?> icao = const i0.Value.absent(),
          }) =>
              i2.FlightAerodromesCompanion.insert(
            id: id,
            createDate: createDate,
            writeDate: writeDate,
            isMarkedAsDeleted: isMarkedAsDeleted,
            backendId: backendId,
            name: name,
            icao: icao,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), i0.BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FlightAerodromesTableProcessedTableManager = i0.ProcessedTableManager<
    i0.GeneratedDatabase,
    i2.$FlightAerodromesTable,
    i2.FlightAerodrome,
    i2.$$FlightAerodromesTableFilterComposer,
    i2.$$FlightAerodromesTableOrderingComposer,
    $$FlightAerodromesTableCreateCompanionBuilder,
    $$FlightAerodromesTableUpdateCompanionBuilder,
    (
      i2.FlightAerodrome,
      i0.BaseReferences<i0.GeneratedDatabase, i2.$FlightAerodromesTable,
          i2.FlightAerodrome>
    ),
    i2.FlightAerodrome,
    i0.PrefetchHooks Function({bool backendId})>;
