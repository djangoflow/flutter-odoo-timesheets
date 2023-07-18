import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/app/app.dart';

part 'task_with_external_data.freezed.dart';

@freezed
class TaskWithExternalData with _$TaskWithExternalData {
  const factory TaskWithExternalData({
    required Task task,
    ExternalTask? externalTask,
  }) = _TaskWithExternalData;
}
