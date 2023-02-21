import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/app_xmlrpc_client.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_method.dart';
import 'package:timesheets/features/authentication/authentication.dart';

///Repository to communicate with odoo external_api using xml_rpc
class AuthenticationRepository extends OdooRpcRepositoryBase {
  /// Sends auth request to odoo xml_rpc and fetch user data and returns [User] on success
  Future<User?> connect({
    required String email,
    required String password,
  }) async {
    /// Sends auth request to odoo xml_rpc and returns id on success
    /// false value is returned on invalid email/pass
    var id = await rpcAuthGetMethod(email, password);

    /// Handling response on invalid email/password input
    if (id is bool && id == false) {
      throw const OdooRepositoryException('Invalid Email/Password');
    }

    AppXmlRpcClient.instance.init(password: password, id: id, email: email);

    Map<String, dynamic> filterableFields =
        buildFilterableFields(['name', 'email']);

    ///Fetch user data
    List response = await rpcGetObject(
      odooModel: usersModel,
      method: OdooApiMethod.read.name,
      parameters: [
        [
          id,
        ],
        filterableFields,
      ],
    );

    ///Response is returned as List<Map<String,dynamic>>, using 0th index to get userData
    Map<String, dynamic> userData = response[0];

    return User.fromJson(userData);
  }
}
