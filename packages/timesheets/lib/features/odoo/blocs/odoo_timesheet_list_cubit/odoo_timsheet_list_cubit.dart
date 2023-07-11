import 'package:list_bloc/list_bloc.dart';
import 'package:timesheets/features/odoo/data/models/odoo_timesheet.dart';
import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';
import 'package:timesheets/features/odoo/odoo.dart';

class OdooTimesheetListCubit
    extends ListCubit<OdooTimesheet, OdooTimesheetListFilter> {
  final OdooTimesheetRepository _odooTimesheetRepository;

  OdooTimesheetListCubit(this._odooTimesheetRepository)
      : super(_odooTimesheetRepository.getTimesheetList);

  Future<void> updateOdooTimesheet(OdooTimesheet timesheet) async {
    await _odooTimesheetRepository.update(timesheet);
    if (state.data != null) {
      emit(state.copyWith(
        data: [
          for (final item in state.data!)
            if (item.id == timesheet.id) timesheet else item
        ],
      ));
    } else {
      emit(Data(data: [timesheet], filter: state.filter));
    }
  }

  Future<void> deleteOdooTimesheet(OdooTimesheet timesheet) async {
    await _odooTimesheetRepository.delete(timesheet);
    if (state.data != null) {
      emit(state.copyWith(
        data: [
          for (final item in state.data!)
            if (item.id != timesheet.id) item
        ],
      ));
    } else {
      emit(Data.empty(data: [], filter: state.filter));
    }
  }

  Future<void> createOdooTimesheet(OdooTimesheet timesheet) async {
    await _odooTimesheetRepository.create(timesheet);
    if (state.data != null) {
      emit(state.copyWith(
        data: [
          ...state.data!,
          timesheet,
        ],
      ));
    } else {
      emit(Data(data: [timesheet], filter: state.filter));
    }
  }
}
