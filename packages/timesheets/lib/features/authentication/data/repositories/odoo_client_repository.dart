import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:timesheets/utils/http_client/http_client.dart';

class OdooClientRepository implements OdooClientManager {
  OdooClientRepository();
  OdooClient? _odooClient;

  @override
  OdooClient? getClient() => _odooClient;

  @override
  void initializeClient(String baseUrl, {OdooSession? session}) {
    _odooClient = ExtendedOdooClient(
      baseUrl,
      sessionId: session,
      isWebPlatform: kIsWeb,
      httpClient: getHttpClient(),
    );
  }
}
