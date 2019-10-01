import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';

class ConnectionStream {
  ConnectionStream._internal(); // A private constructor for the class
  static final ConnectionStream _instance = ConnectionStream._internal();
  static ConnectionStream get instance => _instance;
  Connectivity _connectivity = Connectivity();
  StreamController _controller = StreamController.broadcast();
  Stream get stream => _controller.stream;

  void initialize() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup("example.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
