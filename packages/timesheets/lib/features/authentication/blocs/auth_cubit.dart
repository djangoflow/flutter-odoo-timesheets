import 'package:djangoflow_app/djangoflow_app.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_authentication_repository.dart';
import 'package:timesheets/features/odoo/odoo.dart';

import 'auth_state.dart';
export 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  static AuthCubit get instance => _instance;
  static final AuthCubit _instance = AuthCubit._internal();
  OdooAuthenticationRepository? _odooAuthenticationRepository;
  // TODO need to use local db to retrieve and save user credentials.
  // It should hold list of backends and credentials for each backend.

  AuthCubit._internal() : super(const AuthState());

  void initialize(OdooAuthenticationRepository odooAuthenticationRepository) {
    if (_odooAuthenticationRepository != null) {
      throw Exception('Already initialized');
    }

    _odooAuthenticationRepository = odooAuthenticationRepository;
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) => AuthState.fromJson(json);

  void _odooLogin(
    OdooUser user,
    String password,
    String serverUrl,
    String db,
  ) =>
      emit(
        state.copyWith(
          odooUser: user,
          odooCredentials: OdooCredentials(
            password: password,
            serverUrl: serverUrl,
            db: db,
            id: user.id,
          ),
        ),
      );

  void logout() {
    emit(
      state.copyWith(
        odooUser: null,
        odooCredentials: state.odooCredentials?.copyWith(
          id: null,
          password: null,
        ),
      ),
    );
  }

  Future<void> loginWithOdoo({
    required String email,
    required String password,
    required String serverUrl,
    required String db,
  }) async {
    try {
      if (_odooAuthenticationRepository == null) {
        throw Exception('AuthCubit not initialized');
      }
      final user = await _odooAuthenticationRepository?.connect(
        email: email,
        password: password,
        serverUrl: serverUrl,
        db: db,
      );
      if (user != null) {
        _odooLogin(user, password, serverUrl, db);
      }
    } on OdooRepositoryException catch (e) {
      DjangoflowAppSnackbar.showError(e.message);
    } on Exception catch (e) {
      DjangoflowAppSnackbar.showError(e.toString());
    }
  }

  bool get isAuthenticated => state.odooUser != null;

  @override
  Map<String, dynamic>? toJson(AuthState state) => state.toJson();
}
