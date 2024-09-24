import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/foundation.dart';

class ConnectionStateProvider
    with ChangeNotifier
    implements ConnectionStateManager {
  bool _isOnline = true;

  @override
  bool get isOnline => _isOnline;

  set isOnline(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  @override
  Stream<bool> get connectionStateStream => throw UnimplementedError();

  @override
  Future<void> checkConnection() => throw UnimplementedError();
}
