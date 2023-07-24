import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheets/features/app/app.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @BackendsConverter() @Default(<Backend>[]) List<Backend> connectedBackends,
    String? lastConnectedOdooServerUrl,
    String? lastConnectedOdooDb,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

class BackendsConverter
    implements JsonConverter<List<Backend>, List<Map<String, dynamic>>> {
  const BackendsConverter();
  @override
  List<Backend> fromJson(List<Map<String, dynamic>> json) =>
      json.map((e) => Backend.fromJson(e)).toList();

  @override
  List<Map<String, dynamic>> toJson(List<Backend> object) =>
      object.map((e) => e.toJson()).toList();
}
