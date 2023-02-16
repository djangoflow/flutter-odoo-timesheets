import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;

///Repository to communicate with odoo external_api using xml_rpc
class OdooRepositoryBase {
  Uri getCommonUri() => Uri.parse(kBaseUrl + kCommonEndpoint);

  Uri getObjectUri() => Uri.parse(kBaseUrl + kObjectEndpoint);

  Future getCommon(String email, String password, String method) async {
    List rpcParams = [db, email, password, []];

    try {
      var response = await xml_rpc.call(
        getCommonUri(),
        method,
        rpcParams,
      );

      return response;
    } catch (e) {
      handleError(e);
    }
  }

  /// Performs various operations like read, search, update, add, edit data
  /// based on [model], [methods] and parameters
  Future getObject(
    int id,
    String password,
    String model,
    String method,
    List parameters, {
    Map<String, dynamic>? optionalParams,
  }) async {
    List rpcParams = [
      db,
      id,
      password,
      model,
      method,
      parameters,
    ];

    if (optionalParams != null) {
      rpcParams.add(optionalParams);
    }

    try {
      var response = await xml_rpc.call(getObjectUri(), rpcFunction, rpcParams);

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
