import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/odoo.dart';
import 'package:xml_rpc/client_c.dart' as xml_rpc;

class OdooXmlRpcClient {
  Map<int, OdooCredentials> _backendCredentials = {};

  set backendCrednetials(
    Map<int, OdooCredentials> backendCredentials,
  ) {
    _backendCredentials = backendCredentials;
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

    /// Backend ID of odoo type backend that is making the request from
    required int backendId,
  }) async {
    final odooCredentials = _backendCredentials[backendId];
    if (odooCredentials == null) {
      throw Exception('Credentials not set');
    } else {
      Uri uri = Uri.parse('${odooCredentials.serverUrl}$objectEndpoint');
      try {
        final defaultParams = [
          odooCredentials.db,
          odooCredentials.userId,
          odooCredentials.password
        ];

        final response = await xml_rpc.call(uri, rpcFunction, [
          ...defaultParams,
          ...params
        ], headers: {
          'Connection': 'keep-alive',
        });
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
