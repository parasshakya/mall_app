import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';

class NetworkHelper {
  static void observeNetwork() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        // Mobile network available.
        NetworkBloc().add(NetworkNotify(isConnected: true));
      } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
        // Wi-fi is available.
        // Note for Android:
        // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
        NetworkBloc().add(NetworkNotify(isConnected: true));
      } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
        // Ethernet connection available.
      } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
        // Vpn connection active.
        // Note for iOS and macOS:
        // There is no separate network interface type for [vpn].
        // It returns [other] on any device (also simulator)
      } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
        // Bluetooth connection available.
      } else if (connectivityResult.contains(ConnectivityResult.other)) {
        // Connected to a network which is not in the above mentioned networks.
      } else if (connectivityResult.contains(ConnectivityResult.none)) {
        // No available network types
        NetworkBloc().add(NetworkNotify());
      }
    });
  }
}
