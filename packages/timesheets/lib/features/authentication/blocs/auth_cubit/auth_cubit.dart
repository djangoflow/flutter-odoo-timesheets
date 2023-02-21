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
  const factory AuthState({User? user, String? password}) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

class AuthCubit extends HydratedCubit<AuthState> {
  static AuthCubit get instance => _instance;
  static final AuthCubit _instance = AuthCubit._internal();

  final _authenticationRepository = AuthenticationRepository();

  AuthCubit._internal() : super(const AuthState());

  @override
  AuthState? fromJson(Map<String, dynamic> json) => AuthState.fromJson(json);

  void _login(User user, String password) => emit(
        state.copyWith(
          user: user,
          password: password,
        ),
      );

  Future<void> logout() async {
    emit(
      state.copyWith(
        user: null,
      ),
    );
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      User? user = await _authenticationRepository.connect(
        email: email,
        password: password,
      );
      if (user != null) {
        _login(user, password);
      }
    } on OdooRepositoryException catch (e) {
      DjangoflowAppSnackbar.showError(e.message);
    } on Exception catch (e) {
      DjangoflowAppSnackbar.showError(e.toString());
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) => state.toJson();
}
