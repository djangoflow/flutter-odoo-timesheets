import 'package:bloc/bloc.dart';

/// Mixin to add isActive property to Cubit
mixin ActiveStateMixin<T> on Cubit<T> {
  bool _isActive = true;

  void deactivate() {
    _isActive = false;
  }

  void reactivate() {
    _isActive = true;
  }

  bool get isActive => _isActive;
}
