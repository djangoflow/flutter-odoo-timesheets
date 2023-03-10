import 'package:timesheets/configurations/configurations.dart';
import 'package:xml_rpc/client_c.dart' as xml_rpc;

class AppXmlRpcClient {
  int? _id;
  String? _password;
  String? _baseUrl;
  String? _db;

  void updateCredentials({
    int? id,
    String? password,
    String? baseUrl,
    String? db,
  }) {
    _id = id;
    _password = password;
    _baseUrl = baseUrl;
    _db = db;
  }

  Future rpcAuthenticate({
    required String email,
    required String password,
    required String baseUrl,
    required String db,
  }) async {
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
    if (_id == null || _password == null || _baseUrl == null || _db == null) {
      throw Exception('Credentials not set');
    } else {
      Uri uri = Uri.parse('$_baseUrl$objectEndpoint');
      try {
        final defaultParams = [_db, _id, _password];

        final response =
            await xml_rpc.call(uri, rpcFunction, [...defaultParams, ...params]);
        return response;
      } catch (e) {
        rethrow;
      }
    }
  }
}
