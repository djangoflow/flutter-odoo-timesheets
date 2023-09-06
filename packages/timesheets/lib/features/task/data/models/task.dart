import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required int id,
    int? projectId,
    int? stageId,
    String? name,
    String? description,
    String? priority,
    DateTime? dateStart,
    DateTime? dateEnd,
    DateTime? dateDeadline,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
