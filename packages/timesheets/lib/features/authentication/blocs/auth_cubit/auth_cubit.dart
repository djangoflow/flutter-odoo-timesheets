import 'package:djangoflow_app/djangoflow_app.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/app/app.dart';
import 'package:timesheets/features/authentication/data/authentication_repository.dart';
import 'package:timesheets/features/authentication/data/models/user_model.dart';

part 'auth_cubit.freezed.dart';

part 'auth_cubit.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
  }) = _AuthState;

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

  void login(User user) => emit(state.copyWith(user: user));

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
        login(user);
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
