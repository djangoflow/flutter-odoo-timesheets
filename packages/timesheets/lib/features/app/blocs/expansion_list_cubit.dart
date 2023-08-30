import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

class ExpansionListCubit extends Cubit<List<bool>> {
  ExpansionListCubit() : super([]);

  void updateValue(int index, bool value) {
    final updatedList =
        state.mapIndexed((i, e) => i == index ? value : e).toList();
    print(updatedList);
    emit(updatedList);
  }

  void updateList(List<bool> list) => emit(list);
}
