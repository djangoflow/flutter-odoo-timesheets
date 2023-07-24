import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/external/external.dart';
import 'package:timesheets/features/odoo/odoo.dart';

extension BackendListExtensions on List<Backend> {
  List<Backend> getBackendsFilteredByType(BackendTypeEnum backendTypeEnum) =>
      where((element) => element.backendType == backendTypeEnum).toList();

  Map<int, OdooCredentials> get backendCredentialsMap {
    final backendMap = <int, OdooCredentials>{};
    for (final backend in this) {
      backendMap[backend.id] = backend.odooCredentials;
    }
    return backendMap;
  }
}

extension BackendExtensions on Backend {
  OdooCredentials get odooCredentials {
    if (serverUrl != null && db != null && userId != null && password != null) {
      return OdooCredentials(
        serverUrl: serverUrl!,
        db: db!,
        userId: userId!,
        password: password!,
      );
    } else {
      throw Exception('Backend is not of type Odoo or credentials are not set');
    }
  }
}
