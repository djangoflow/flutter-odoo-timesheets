import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/data/repositories/authentication_repository.dart';
import 'package:timesheets/features/authentication/data/models/user_model.dart';

part 'auth_cubit.freezed.dart';

part 'auth_cubit.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    String? password,
    String? serverUrl,
    String? db,
    @Default([]) List<String> availableDbs,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

class AuthCubit extends HydratedCubit<AuthState> {
  static AuthCubit get instance => _instance;
  static final AuthCubit _instance = AuthCubit._internal();
  AuthenticationRepository? _authenticationRepository;

  AuthCubit._internal() : super(const AuthState());

  void initialize(AuthenticationRepository authenticationRepository) {
    if (_authenticationRepository != null) {
      throw Exception('Already initialized');
    }

    _authenticationRepository = authenticationRepository;
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) => AuthState.fromJson(json);

  void _login(
    User user,
    String password,
    String serverUrl,
    String db,
  ) =>
      emit(
        state.copyWith(
          user: user,
          password: password,
          serverUrl: serverUrl,
          db: db,
        ),
      );

  void logout() {
    emit(
      state.copyWith(
        user: null,
        password: null,
      ),
    );
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
    required String serverUrl,
    required String db,
  }) async {
    try {
      if (_authenticationRepository == null) {
        throw Exception('AuthCubit not initialized');
      }
      final user = await _authenticationRepository?.connect(
        email: email,
        password: password,
        serverUrl: serverUrl,
        db: db,
      );
      if (user != null) {
        _login(user, password, serverUrl, db);
      }
    } on OdooRepositoryException catch (e) {
      DjangoflowAppSnackbar.showError(e.message);
    } on Exception catch (e) {
      DjangoflowAppSnackbar.showError(e.toString());
    }
  }

  Future<void> loadDbList(String serverUrl) async {
    if (_authenticationRepository == null) {
      throw Exception('AuthCubit not initialized');
    }
    final dbList = await _authenticationRepository?.getDb(
      serverUrl: serverUrl,
    );
    if (dbList != null) {
      emit(
        state.copyWith(
          availableDbs: dbList,
        ),
      );
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) => state.toJson();
}
