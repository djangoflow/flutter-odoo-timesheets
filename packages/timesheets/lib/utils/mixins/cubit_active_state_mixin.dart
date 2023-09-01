import 'package:bloc/bloc.dart';

mixin ActiveStateMixin<T> on Cubit<T> {
  bool _isActive = true;

  void deactivate() {
    _isActive = false;
    print('deactivate $_isActive');
  }

  void reactivate() {
    _isActive = true;
  }

  bool get isActive => _isActive;
}
