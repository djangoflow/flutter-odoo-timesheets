import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/odoo/odoo.dart';

///Repository to communicate with odoo external_api using xml_rpc
class OdooAuthenticationRepository extends OdooRpcRepositoryBase {
  OdooAuthenticationRepository(super.rpcClient);

  /// Sends auth request to odoo xml_rpc and fetch user data and returns [User] on success
  Future<int> connect({
    required String email,
    required String password,
    required String serverUrl,
    required String db,
  }) async {
    /// Sends auth request to odoo xml_rpc and returns id on success
    /// false value is returned on invalid email/pass
    try {
      var id = await rpcClient.rpcAuthenticate(
        email: email,
        password: password,
        baseUrl: serverUrl,
        db: db,
      );

      /// Handling response on invalid email/password input
      if (id is bool && id == false) {
        throw OdooRepositoryException.fromCode('invalid_cred');
      }

      return id as int;
    } catch (e) {
      throw getHandledException(e);
    }
  }

  Future<OdooUser?> getUserData({
    required int userId,
    required int backendId,
  }) async {
    Map<String, dynamic> filterableFields =
        buildFilterableFields(['name', 'email']);

    ///Fetch user data
    List response = await odooCallMethod(
      odooModel: usersModel,
      method: OdooApiMethod.read.name,
      backendId: backendId,
      parameters: [
        [
          userId,
        ],
        filterableFields,
      ],
    );

    ///Response is returned as List<Map<String,dynamic>>, using 0th index to get userData
    Map<String, dynamic> userData = response[0];

    return OdooUser.fromJson(userData);
  }
}
