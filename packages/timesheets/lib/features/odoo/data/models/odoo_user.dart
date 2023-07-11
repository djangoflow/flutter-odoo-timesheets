import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_user.freezed.dart';
part 'odoo_user.g.dart';

@freezed
class OdooUser with _$OdooUser {
  const factory OdooUser({
    required int id,
    required String name,
    required String email,
  }) = _OdooUser;

  factory OdooUser.fromJson(Map<String, dynamic> json) =>
      _$OdooUserFromJson(json);
}
