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

    // Periodically check network quality
    timer = Timer.periodic(const Duration(seconds: 5), (_) => checkInternet());
  }

  Future<void> _initConnectivity() async {
    final statuses = await Connectivity().checkConnectivity();
    _updateConnectionStatus(statuses);
    await checkInternet();
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // You can pick the first available connection type or handle multiple
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
        if (pingTime > 800) {
          quality = 'slow';
        } else {
          quality = 'good';
        }
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

    switch (_networkQuality) {
      case 'good':
        color = Colors.green;
        icon = Icons.signal_wifi_4_bar;
        break;
      case 'slow':
        color = Colors.orange;
        icon = Icons.signal_wifi_statusbar_4_bar;
        break;
      default:
        color = Colors.red;
        icon = Icons.signal_wifi_off;
    }

    return Icon(icon, color: color);
  }
}
