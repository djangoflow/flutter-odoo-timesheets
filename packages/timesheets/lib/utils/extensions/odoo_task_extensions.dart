import 'package:timesheets/features/odoo/odoo.dart';

extension OdooTaskExtensions on OdooTask {
  int? get projectId => project.length > 1 ? project.first as int : null;
  String? get projectName =>
      project.length == 2 ? project.last as String : null;
}
