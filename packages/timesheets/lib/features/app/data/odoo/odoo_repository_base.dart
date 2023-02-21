import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/app_xmlrpc_client.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;

///Repository to communicate with odoo external_api using xml_rpc
class OdooRpcRepositoryBase {
  final AppXmlRpcClient rpcClient;

  OdooRpcRepositoryBase(this.rpcClient);

  /// Performs various operations like read, search, update, add, edit data
  /// based on [model], [methods] and parameters
  Future odooCallMethod({
    required String odooModel,
    required String method,
    required List parameters,
  }) async {
    try {
      final rpcParams = [
        odooModel,
        method,
        ...parameters,
      ];

      return await rpcClient.rpcCallMethod(
        params: rpcParams,
      );
    } catch (e) {
      handleError(e);
    }
  }

  ///Handles errors generated due to various operations in [OdooRepository] using [OdooRepositoryException]
  handleError(error) {
    if (error is xml_rpc.Fault) {
      throw OdooRepositoryException(error.text);
    } else {
      throw const OdooRepositoryException();
    }
  }

  ///Builds filters so that only relevant data is fetched
  Map<String, dynamic> buildFilterableFields(List fields) => {
        'fields': fields,
      };
}
