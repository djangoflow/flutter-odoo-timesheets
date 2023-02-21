import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_endpoint.dart';
import 'package:xml_rpc/client_c.dart' as xml_rpc;

class AppXmlRpcClient {
  int? _id;
  String? _password;
  String? _email;

  static AppXmlRpcClient get instance => _instance;
  static final AppXmlRpcClient _instance = AppXmlRpcClient._internal();

  AppXmlRpcClient._internal();

  init({
    int? id,
    String? email,
    required String password,
  }) {
    _id = id;
    _password = password;
    _email = email;
  }

  Future callRpc({
    required OdooApiEndpoint endpoint,
    required String rpcFunction,
    required List params,
  }) {
    Uri uri = Uri.parse('$baseUrl${endpoint.name}');
    List clientRpcParams = [db, _password];

    ///Inserting user identifier param based on endpoint
    clientRpcParams.insert(
      1,
      endpoint == OdooApiEndpoint.common ? _email : _id,
    );

    clientRpcParams.addAll(params);

    return xml_rpc.call(uri, rpcFunction, clientRpcParams);
  }
}
