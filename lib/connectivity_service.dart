import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    try {
      final lookup = await InternetAddress.lookup('example.com');
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
