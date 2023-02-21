import 'package:timesheets/configurations/configurations.dart';
import 'package:xml_rpc/client_c.dart' as xml_rpc;

class AppXmlRpcClient {
  int? _id;
  String? _password;

  void updateCredentials({
    int? id,
    String? password,
  }) {
    _id = id;
    _password = password;
  }

  Future rpcAuthenticate(
      {required String email, required String password}) async {
    Uri uri = Uri.parse('$baseUrl$commonEndpoint');

    final response = await xml_rpc.call(
      uri,
      rpcAuthenticationFunction,
      [db, email, password, []],
    );
    return response;
  }

  Future rpcCallMethod({
    required List params,
  }) async {
    Uri uri = Uri.parse('$baseUrl$objectEndpoint');
    if (_id == null || _password == null) {
      throw Exception('Credentials not set');
    } else {
      try {
        final defaultParams = [db, _id, _password];

        final response =
            await xml_rpc.call(uri, rpcFunction, [...defaultParams, ...params]);
        return response;
      } catch (e) {
        rethrow;
      }
    }
  }
}