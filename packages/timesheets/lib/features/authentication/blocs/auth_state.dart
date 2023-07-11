import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/odoo/odoo.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    OdooUser? odooUser,
    OdooCredentials? odooCredentials,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
