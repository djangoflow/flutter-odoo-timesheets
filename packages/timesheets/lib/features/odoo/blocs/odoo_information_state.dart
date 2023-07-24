import 'package:freezed_annotation/freezed_annotation.dart';

part 'odoo_information_state.freezed.dart';
part 'odoo_information_state.g.dart';

@freezed
class OdooInformationState with _$OdooInformationState {
  const factory OdooInformationState({
    @Default(<String>[]) List<String> dbList,
  }) = _OdooInformationState;

  factory OdooInformationState.fromJson(Map<String, dynamic> json) =>
      _$OdooInformationStateFromJson(json);
}
