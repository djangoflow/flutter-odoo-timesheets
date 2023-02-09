import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/authentication/data/models/user_model.dart';

part 'auth_cubit.freezed.dart';

part 'auth_cubit.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    String? token,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

class AuthCubit extends HydratedCubit<AuthState> {
  // TODO uncomment this line after generating openapi
  // AuthApi get _authApi => ApiRepository.instance.auth;

  // TODO remove dummy variables _kDuration, _kToken, _kUser
  final _kDuration = const Duration(
    seconds: 2,
  );
  final _kToken = '__dummy_token__';
  final _kUser = User(
    id: '__dummy_user__',
    email: 'dummy@user.com',
    firstName: 'dummy first name',
    lastName: 'dummy last name',
    displayName: 'dummy dislay name',
  );

  static AuthCubit get instance => _instance;
  static final AuthCubit _instance = AuthCubit._internal();

  AuthCubit._internal() : super(const AuthState());

  @override
  AuthState? fromJson(Map<String, dynamic> json) => AuthState.fromJson(json);

  void login(User user, String token) =>
      emit(state.copyWith(user: user, token: token));

  Future<void> logout() async {
    emit(
      state.copyWith(
        user: null,
        token: null,
      ),
    );
  }

  Future<void> registrationWithEmail({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    await Future.delayed(_kDuration);
    // await _authApi.authTokenSignupCreate(
    //   signupRequest: SignupRequest(
    //     email: email,
    //     firstName: firstName,
    //     lastName: lastName,
    //   ),
    // );

    // await requestOTP(email: email);
  }

  Future<void> requestOTP({required String email}) async =>
      await Future.delayed(_kDuration);

  // (await _authApi.authOtpCreate(
  //   oTPObtainRequest: OTPObtainRequest(email: email),
  // ))
  //     .data;

  Future<void> loginWithEmailOTP({
    required String email,
    required String otp,
  }) async {
    await Future.delayed(_kDuration);
    // final tokenResult = (await _authApi.authTokenCreate(
    //   tokenObtainRequest: TokenObtainRequest(
    //     email: email,
    //     otp: otp,
    //   ),
    // ))
    //     .data;
    // final token = tokenResult?.token;

    await _loginUsingToken(_kToken);

    // return tokenResult;
  }

  Future<User> _fetchCurrentUser() async {
    await Future.delayed(_kDuration);
    return _kUser;
  }

  // (await AccountsUsersRepository.retrieve(
  //   const AccountsUsersRetrieveFilter(
  //     id: '0', // 0 indicates the current user from token
  //   ),
  // ));

  Future<void> _loginUsingToken(String? token) async {
    if (token != null) {
      emit(state.copyWith(
        token: token,
      ));
      final user = await _fetchCurrentUser();
      login(user, token);
    } else {
      throw Exception('Could not retrieve token');
    }
  }

  Future<void> loginWithMagicLink({required String magiclink}) async {
    try {
      await Future.delayed(_kDuration);
      await loginWithEmailOTP(email: 'dummy@email.com', otp: '123567');
      // final credentials = utf8
      //     .decode(base64.decode(const Base64Codec().normalize(magiclink)))
      //     .split('/');
      // await loginWithEmailOTP(email: credentials[0], otp: credentials[1]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reload() async {
    final user = await _fetchCurrentUser();
    emit(
      state.copyWith(
        user: user,
      ),
    );
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) => state.toJson();
}
