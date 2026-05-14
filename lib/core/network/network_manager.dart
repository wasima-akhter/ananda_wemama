import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkManager {
  final Connectivity connectivity = Connectivity();

  Future<bool> checkConnection() async {
    try {
      // First check device connectivity type
      final result = await connectivity.checkConnectivity();

      if (result.contains(ConnectivityResult.none)) {
        // No network available
        return false;
      }

      return true;

      // Then check actual internet access
      // final lookupResult = await InternetAddress.lookup(
      //   'www.google.com',
      // ).timeout(Duration(seconds: 5));
      // return lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty;
    } catch (e) {
      // Any exception means no internet
      return false;
    }
  }

  Stream<bool> networkStream() async* {
    await for (var results in Connectivity().onConnectivityChanged) {
      if (results.contains(ConnectivityResult.none)) {
        yield false;
      } else {
        yield true;
      }
    }
  }
}
