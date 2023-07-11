// freezed class with password, serverUrl, db, id
import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_credentials.freezed.dart';
part 'odoo_credentials.g.dart';

@freezed
class OdooCredentials with _$OdooCredentials {
  const factory OdooCredentials({
    int? id,
    String? password,
    String? serverUrl,
    String? db,
  }) = _OdooCredentials;

  factory OdooCredentials.fromJson(Map<String, dynamic> json) =>
      _$OdooCredentialsFromJson(json);
}
