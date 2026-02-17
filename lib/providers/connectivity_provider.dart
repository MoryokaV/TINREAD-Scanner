import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tinread_scanner/services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier with WidgetsBindingObserver {
  final ConnectivityService _service = ConnectivityService();

  bool _isChecking = false;
  Timer? _timer;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    WidgetsBinding.instance.addObserver(this);

    startMonitoring();
  }

  void startMonitoring() {
    _timer?.cancel();
    _checkStatus();

    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _checkStatus());
  }

  void _startAdaptiveTimer() {
    _timer?.cancel();

    // Performance Strategy:
    // If Online  -> Check slowly (15s) to save battery
    // If Offline -> Check quickly (5s) to detect reconnection fast
    final duration = _isOnline ? const Duration(seconds: 15) : const Duration(seconds: 5);

    _timer = Timer.periodic(duration, (_) => _checkStatus());

    _checkStatus();
  }

  void stopMonitoring() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    stopMonitoring();

    super.dispose();
  }

  Future<void> _checkStatus() async {
    // prevent overlapping
    if (_isChecking) return;
    _isChecking = true;

    bool newStatus = await _service.checkApiConnection();

    _isChecking = false;

    if (_isOnline != newStatus) {
      // Performance tip: notify only if the status changed
      _isOnline = newStatus;

      notifyListeners();
      _startAdaptiveTimer();
    }
  }

  // Performance improvement: pause check when app is minimized
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startMonitoring();
    } else if (state == AppLifecycleState.paused) {
      stopMonitoring();
    }
  }
}
