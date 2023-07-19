// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/odoo/data/odoo_null_field_converter.dart';

part 'odoo_task.freezed.dart';
part 'odoo_task.g.dart';

@Freezed(
  genericArgumentFactories: true,
)
class OdooTask with _$OdooTask {
  const factory OdooTask({
    required int id,

    /// List with project_id at [0] and project_name [1]
    @JsonKey(name: 'project_id') required List<Object> project,
    @JsonKey(
      name: 'date_start',
      fromJson: OdooNullValueJsonConverter.fromJsonOrNull<DateTime>,
      toJson: OdooNullValueJsonConverter.toJsonOrNull<DateTime>,
    )
    DateTime? dateStart,
    @JsonKey(
      name: 'date_end',
      fromJson: OdooNullValueJsonConverter.fromJsonOrNull<DateTime>,
      toJson: OdooNullValueJsonConverter.toJsonOrNull<DateTime>,
    )
    DateTime? dateEnd,
    @JsonKey(
      name: 'date_deadline',
      fromJson: OdooNullValueJsonConverter.fromJsonOrNull<DateTime>,
      toJson: OdooNullValueJsonConverter.toJsonOrNull<DateTime>,
    )
    DateTime? dateDeadline,
    String? priority,
    int? color,
    required String name,
    @JsonKey(
      name: 'timesheet_ids',
    )
    List<int>? timesheetIds,
  }) = _OdooTask;

  factory OdooTask.fromJson(Map<String, dynamic> json) =>
      _$OdooTaskFromJson(json);
}


//  IntColumn get stageId => integer().nullable()();
//   TextColumn get name => text().nullable()();
//   IntColumn get priority => integer().nullable()();
//   DateTimeColumn get dateStart => dateTime().nullable()();
//   DateTimeColumn get dateEnd => dateTime().nullable()();
//   DateTimeColumn get dateDeadline => dateTime().nullable()();
//   BoolColumn get active => boolean().nullable()();

//   DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
//   DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();


