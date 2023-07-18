import 'package:timesheets/configurations/configurations.dart';
import 'package:xml_rpc/client_c.dart' as xml_rpc;

class OdooXmlRpcClient {
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

  // TODO : Add a way to fetch credentials from db using backendId
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

  Future<List<String>> getDbList(String serverUrl, {String? search}) async {
    Uri uri = Uri.parse('$serverUrl$dbEndpoint');
    try {
      final response = await xml_rpc.call(
        uri,
        'list',
        [],
      );
      if (response != null) {
        return response.cast<String>();
      } else {
        throw Exception('No response from server');
      }
    } catch (e) {
      rethrow;
    }
  }
}
