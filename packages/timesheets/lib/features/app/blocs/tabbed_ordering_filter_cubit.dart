import 'package:bloc/bloc.dart';
import 'package:timesheets/features/app/app.dart';

class TabbedOrderingFilterCubit extends Cubit<Map<int, OrderingFilter>> {
  TabbedOrderingFilterCubit(super.initialState);

  void updateFilter(int tabIndex, OrderingFilter filter) {
    final updatedState = Map<int, OrderingFilter>.from(state);
    updatedState[tabIndex] = filter;
    emit(updatedState);
  }

  OrderingFilter? getFilterForTab(int tabIndex) => state[tabIndex];
}
