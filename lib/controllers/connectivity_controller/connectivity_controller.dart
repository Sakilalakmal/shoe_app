import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityController {
  // Function to check connectivity status
  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none; // true if online, false if offline
  }
}