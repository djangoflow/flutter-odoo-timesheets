import 'package:bloc/bloc.dart';
import 'package:timesheets/features/app/app.dart';

class TabbedOrderingFilterCubit<T> extends Cubit<Map<int, OrderingFilter<T>>> {
  TabbedOrderingFilterCubit(super.initialState);

  void updateFilter(int tabIndex, OrderingFilter<T> filter) {
    final updatedState = Map<int, OrderingFilter<T>>.from(state);
    updatedState[tabIndex] = filter;
    emit(updatedState);
  }

  OrderingFilter<T>? getFilterForTab(int tabIndex) => state[tabIndex];
}
