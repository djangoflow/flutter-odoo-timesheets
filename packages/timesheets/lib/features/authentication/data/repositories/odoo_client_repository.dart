import 'package:djangoflow_odoo_auth/djangoflow_odoo_auth.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class OdooClientRepository implements OdooClientManager {
  OdooClient? _odooClient;

  OdooClientRepository();

  @override
  OdooClient? getClient() => _odooClient;

  @override
  void initializeClient(String baseUrl, {OdooSession? session}) {
    _odooClient = ExtendedOdooClient(baseUrl, session);
  }
}
