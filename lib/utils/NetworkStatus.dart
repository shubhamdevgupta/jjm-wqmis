import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkStatusIcon extends StatefulWidget {
  const NetworkStatusIcon({super.key});

  @override
  State<NetworkStatusIcon> createState() => _NetworkStatusIconState();
}

class _NetworkStatusIconState extends State<NetworkStatusIcon> {
  late StreamSubscription connectivitySubscription;
  late Timer timer;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  String _networkQuality = 'none'; // 'good', 'slow', 'none'

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);

    // Periodically check network quality (ping test)
    timer = Timer.periodic(const Duration(seconds: 5), (_) => checkInternet());
  }

  Future<void> _initConnectivity() async {
    final status = await Connectivity().checkConnectivity();
    _updateConnectionStatus(status);
    await checkInternet();
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    setState(() {
      _connectionStatus = result;
    });
  }


  Future<void> checkInternet() async {
    final hasInternet = await InternetConnectionChecker().hasConnection;
    String quality = 'none';

    if (_connectionStatus == ConnectivityResult.none || !hasInternet) {
      quality = 'none';
    } else {
      final startTime = DateTime.now();
      try {
        await InternetAddress.lookup('google.com');
        final pingTime = DateTime.now().difference(startTime).inMilliseconds;
        quality = pingTime > 800 ? 'slow' : 'good';
      } catch (_) {
        quality = 'none';
      }
    }

    if (mounted) {
      setState(() {
        _networkQuality = quality;
      });
    }
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String tooltipText;

    if (_connectionStatus == ConnectivityResult.mobile) {
      // Mobile Data
      switch (_networkQuality) {
        case 'good':
          color = Colors.green;
          icon = Icons.signal_cellular_4_bar;
          tooltipText = 'Mobile Data: Good';
          break;
        case 'slow':
          color = Colors.orange;
          icon = Icons.signal_cellular_connected_no_internet_4_bar;
          tooltipText = 'Mobile Data: Slow';
          break;
        default:
          color = Colors.red;
          icon = Icons.signal_cellular_off;
          tooltipText = 'Mobile Data: Disconnected';
      }
    } else if (_connectionStatus == ConnectivityResult.wifi) {
      // Wi-Fi
      switch (_networkQuality) {
        case 'good':
          color = Colors.green;
          icon = Icons.wifi;
          tooltipText = 'Wi-Fi: Good';
          break;
        case 'slow':
          color = Colors.orange;
          icon = Icons.wifi_lock;
          tooltipText = 'Wi-Fi: Slow';
          break;
        default:
          color = Colors.red;
          icon = Icons.wifi_off;
          tooltipText = 'Wi-Fi: Disconnected';
      }
    } else {
      // No connection
      color = Colors.grey;
      icon = Icons.signal_wifi_off;
      tooltipText = 'No Internet Connection';
    }

    return Tooltip(
      message: tooltipText,
      child: Icon(icon, color: color),
    );
  }
}
