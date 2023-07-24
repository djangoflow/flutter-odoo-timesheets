import 'package:timesheets/features/odoo/odoo.dart';

class OdooInformationRepository extends OdooRpcRepositoryBase {
  OdooInformationRepository(super.rpcClient);

  Future<List<String>> getDb({required String serverUrl}) async =>
      await rpcClient.getDbList(serverUrl);
}
