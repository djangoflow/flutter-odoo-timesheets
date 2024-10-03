import 'dart:async';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionStateProvider
    with ChangeNotifier
    implements ConnectionStateManager {
  ConnectionStateProvider() {
    // Initialize the connection state
    checkConnection();

    // Listen to connection changes
    InternetConnection().onStatusChange.listen((status) {
      isOnline = status == InternetStatus.connected;
    });
  }

  bool _isOnline = true;

  @override
  bool get isOnline => _isOnline;

  set isOnline(bool value) {
    if (_isOnline != value) {
      _isOnline = value;
      notifyListeners();
    }
  }

  final _connectionStateController = StreamController<bool>.broadcast();

  @override
  Stream<bool> get connectionStateStream => _connectionStateController.stream;

  @override
  Future<bool> checkConnection() async {
    if (kDebugMode) {
      return isOnline;
    }
    try {
      final result = await InternetConnection().hasInternetAccess;
      isOnline = result;
      _connectionStateController.add(result);
      return result;
    } catch (e) {
      logger.e('Error checking internet connection: $e');
      isOnline = false;
      _connectionStateController.add(false);
      return false;
    }
  }

  @override
  void dispose() {
    _connectionStateController.close();
    super.dispose();
  }
}
