// import 'package:list_bloc/list_bloc.dart';
// import 'package:timesheets/features/odoo/data/models/odoo_timesheet.dart';
// import 'package:timesheets/features/odoo/data/repositories/odoo_timesheet_repository.dart';
// import 'package:timesheets/features/odoo/odoo.dart';

// class OdooTimesheetListCubit
//     extends ListCubit<OdooTimesheet, OdooTimesheetListFilter> {
//   final OdooTimesheetRepository _odooTimesheetRepository;

//   OdooTimesheetListCubit(this._odooTimesheetRepository)
//       : super(_odooTimesheetRepository.getTimesheetList);

//   Future<void> updateOdooTimesheet(OdooTimesheetRequest timesheet) async {
//     final updatedOdooTimesheet =
//         await _odooTimesheetRepository.update(timesheet);
//     if (updatedOdooTimesheet == null) {
//       throw Exception('Failed to update timesheet');
//     }
//     if (state.data != null) {
//       emit(state.copyWith(
//         data: [
//           for (final item in state.data!)
//             if (item.id == updatedOdooTimesheet.id)
//               updatedOdooTimesheet
//             else
//               item
//         ],
//       ));
//     } else {
//       emit(Data(data: [updatedOdooTimesheet], filter: state.filter));
//     }
//   }

//   Future<void> deleteOdooTimesheet(OdooTimesheetRequest timesheet) async {
//     final odooTimesheetId = timesheet.id;
//     if (odooTimesheetId == null) {
//       throw Exception('Failed to delete timesheet');
//     }
//     await _odooTimesheetRepository.delete(timesheet);
//     if (state.data != null) {
//       emit(state.copyWith(
//         data: [
//           for (final item in state.data!)
//             if (item.id != odooTimesheetId) item
//         ],
//       ));
//     } else {
//       emit(Data.empty(data: [], filter: state.filter));
//     }
//   }

//   Future<void> createOdooTimesheet(OdooTimesheetRequest timesheet) async {
//     final timesheetId = await _odooTimesheetRepository.create(timesheet);
//     final odooTimesheet =
//         await _odooTimesheetRepository.getTimesheetById(timesheetId);
//     if (odooTimesheet == null) {
//       throw Exception('Failed to create timesheet');
//     }
//     if (state.data != null) {
//       emit(state.copyWith(
//         data: [
//           ...state.data!,
//           odooTimesheet,
//         ],
//       ));
//     } else {
//       emit(Data(data: [odooTimesheet], filter: state.filter));
//     }
//   }
// }
