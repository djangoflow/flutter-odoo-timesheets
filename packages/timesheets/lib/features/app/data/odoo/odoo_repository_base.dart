import 'dart:io';

import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/configurations/configurations.dart';
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
      throw OdooRepositoryException.fromCode(error.text);
    } else if (error is SocketException ||
        error is ArgumentError ||
        error is FormatException) {
      throw OdooRepositoryException.fromCode(error.message);
    } else {
      throw const OdooRepositoryException();
    }
  }

  ///Builds filters so that only relevant data is fetched
  Map<String, dynamic> buildFilterableFields(List filterableFields) => {
        fields: filterableFields,
      };
}
