import 'package:timesheets/features/odoo/odoo.dart';

extension OdooTaskExtensions on OdooTask {
  int? get projectId => project.length > 1 ? project[0] as int : null;
  String? get projectName => project.length > 2 ? project[1] as String : null;
}
