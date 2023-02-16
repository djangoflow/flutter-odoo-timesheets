import 'package:timesheets/configurations/configurations.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/app/data/odoo/odoo_api_method.dart';
import 'package:timesheets/features/authentication/authentication.dart';

///Repository to communicate with odoo external_api using xml_rpc
class AuthenticationRepository extends OdooRepositoryBase {
  /// Sends auth request to odoo xml_rpc and fetch user data and returns [User] on success
  Future<User?> connect(String email, String password) async {
    /// Sends auth request to odoo xml_rpc and returns id on success
    /// false value is returned on invalid email/pass
    var id = await getCommon(email, password, 'authenticate');

    /// Handling response on invalid email/password input
    if (id is bool && id == false) {
      throw const OdooRepositoryException('Invalid Email/Password');
    }

    Map<String, dynamic> filterableFields =
        buildFilterableFields(['name', 'email']);

    ///Fetch user data
    List response = await getObject(
      id,
      password,
      usersMethod,
      OdooApiMethod.read.name,
      [id],
      optionalParams: filterableFields,
    );

    ///Response is returned as List<Map<String,dynamic>>, using 0th index to get userData
    Map<String, dynamic> userData = response[0];

    ///Adding password as future execute_kw calls require password
    userData['pass'] = password;

    return User.fromJson(userData);
  }
}
