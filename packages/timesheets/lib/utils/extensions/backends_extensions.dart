import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';

extension BackendListExtension on List<Backend> {
  List<Backend> getBackendsFilteredByType(BackendTypeEnum backendTypeEnum) =>
      where((element) => element.backendType == backendTypeEnum).toList();
}
