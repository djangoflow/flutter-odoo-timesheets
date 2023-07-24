import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:timesheets/configurations/configurations.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;

import '../odoo_repository_exception.dart';
import '../odoo_xmlrpc_client.dart';

///Repository to communicate with odoo external_api using xml_rpc
class OdooRpcRepositoryBase {
  final OdooXmlRpcClient rpcClient;

  OdooRpcRepositoryBase(this.rpcClient);

  /// Performs various operations like read, search, update, add, edit data
  /// based on [model], [methods] and parameters
  Future odooCallMethod({
    required String odooModel,
    required String method,
    required List parameters,
    required int backendId,
  }) async {
    try {
      final rpcParams = [
        odooModel,
        method,
        ...parameters,
      ];

      return await rpcClient.rpcCallMethod(
        params: rpcParams,
        backendId: backendId,
      );
    } catch (e) {
      debugPrint(e.toString());
      throw getHandledException(e);
    }
  }

  ///Handles errors generated due to various operations in [OdooRepository] using [OdooRepositoryException]
  OdooRepositoryException getHandledException(error) {
    if (error is xml_rpc.Fault) {
      return OdooRepositoryException.fromCode(error.text);
    } else if ((!kIsWeb && error is SocketException)) {
      return const OdooRepositoryException('Seems like you are offline!');
    } else if (error is ArgumentError || error is FormatException) {
      return OdooRepositoryException.fromCode(error.message);
    } else if (error is OdooRepositoryException) {
      return error;
    } else {
      return const OdooRepositoryException();
    }
  }

  ///Builds filters so that only relevant data is fetched
  Map<String, dynamic> buildFilterableFields(List filterableFields) => {
        fields: filterableFields,
      };
}
