import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_endpoint.dart';
import 'package:timesheets/features/authentication/blocs/auth_cubit/auth_cubit.dart';
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
// TODO try to follow this approach
// class RpcClient {
//   String? _id, _password;

//   void updateCredentials({
//     String? id,
//     String? password,
//   }) {
//     _id = id;
//     _password = password;
//   }

//   Future rpcAuthenticate(
//       {required String email, required String password}) async {
//     Uri uri = Uri.parse('$baseUrl$commonEndpoint');

//     final response = await xml_rpc.call(uri, rpcFunction, [db]);
//     return response;
//   }

//   Future rpcCallMethod({
//     required OdooApiEndpoint endpoint,
//     required String rpcFunction,
//     required List params,
//   }) async {
//     Uri uri = Uri.parse('$baseUrl${endpoint.name}');
//     if (_id == null || _password == null) {
//       throw Exception('Credentials not set');
//     } else {
//       final defaultParams = [db, _id, _password];

//       final response = await xml_rpc.call(uri, rpcFunction, [...defaultParams, ...params]);
//       return response;
//     }
//   }
// }

// class OdooRepository {
//   final RpcClient rpcClient;

//   OdooRepository(this.rpcClient);

//   Future rpcCallMethod({
//     required OdooApiEndpoint endpoint,
//     required String rpcFunction,
//     required List params,
//   }) =>
//       rpcClient.rpcCallMethod(
//           endpoint: endpoint, rpcFunction: rpcFunction, params: params);
// }

// class TestAuthRepository extends OdooRepository {
//   TestAuthRepository(super.rpcClient);

//   Future rpcAuthenticate(
//       {required String email, required String password}) async {
//     final response = await rpcClient.rpcCallMethod(
//       endpoint: OdooApiEndpoint.common,
//       rpcFunction: rpcAuthenticationFunction,
//       params: [email, password],
//     );

//     return response;
//   }
// }
