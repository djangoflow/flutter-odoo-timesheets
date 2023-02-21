import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/app_xmlrpc_client.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_endpoint.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;

///Repository to communicate with odoo external_api using xml_rpc
class OdooRpcRepositoryBase {
  Uri getCommonUri() => Uri.parse(baseUrl + commonEndpoint);

  final AppXmlRpcClient _appXmlRpcClient = AppXmlRpcClient.instance;

  // TODO: rename this to something meaningful, like `rpcAuthGetMethod(method)`
  // TODO: pass the email, password in a DRY way
  Future rpcAuthGetMethod(String email, String password) async {
    List rpcParams = [db, email, password, []];

    try {
      // TODO create AppXmlRpcClient wrapper, that will handle baseUrl, common rpc params for auth,db etc.
      var response = await xml_rpc.call(
        getCommonUri(),
        rpcAuthenticationFunction,
        rpcParams,
      );

      return response;
    } catch (e) {
      handleError(e);
    }
  }

  /// Performs various operations like read, search, update, add, edit data
  /// based on [model], [methods] and parameters
  Future rpcGetObject({
    required String odooModel,
    required String method,
    required List parameters,
  }) async {
    List rpcParams = [
      odooModel,
      method,
      ...parameters,
    ];

    try {
      var response = await _appXmlRpcClient.callRpc(
        endpoint: OdooApiEndpoint.object,
        rpcFunction: rpcFunction,
        params: rpcParams,
      );

      return response;
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
