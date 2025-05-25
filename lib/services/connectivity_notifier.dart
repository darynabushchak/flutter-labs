import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityNotifier {
  final _controller = StreamController<bool>.broadcast();
  late final StreamSubscription<ConnectivityResult> _subscription;

  ConnectivityNotifier() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final isConnected = result != ConnectivityResult.none;
      _controller.add(isConnected);
    });
  }

  Stream<bool> get onStatusChange => _controller.stream;

  Future<bool> getInitialStatus() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
