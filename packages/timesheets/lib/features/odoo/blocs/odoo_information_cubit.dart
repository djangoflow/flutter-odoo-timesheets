import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:timesheets/features/odoo/blocs/odoo_information_state.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_information_repository.dart';

export 'odoo_information_state.dart';

class OdooInformationCubit extends Cubit<OdooInformationState> {
  OdooInformationCubit(this._odooInformationRepository)
      : super(const OdooInformationState());
  final OdooInformationRepository _odooInformationRepository;

  Future<void> getDbList(String serverUrl) async {
    final dbList = await _odooInformationRepository.getDb(serverUrl: serverUrl);
    emit(state.copyWith(dbList: dbList));
  }
}
