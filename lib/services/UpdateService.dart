import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class UpdateService extends ChangeNotifier{
  final String updateInfoUrl = 'https://raw.githubusercontent.com/shubhamdevgupta/jjm-wqmis/update_app/assets/update_info.json';

  Future<Map<String, dynamic>?> fetchUpdateInfo() async {
    try {
      final response = await http.get(Uri.parse(updateInfoUrl));  // <--- READ update_info.json
      if (response.statusCode == 200) {
        print("ressssssssssssssssss ${response.body}");
        return jsonDecode(response.body);

      }
    } catch (e) {
      print('Error fetching update info: $e');
    }
    finally{
      notifyListeners();
    }
  }

  Future<bool> isUpdateAvailable() async {
    final updateInfo = await fetchUpdateInfo();  // <--- GET the Map
    if (updateInfo == null) return false;

    final currentVersion = '1.0.0';
    final latestVersion = updateInfo['version'];
    print("currentVersion $currentVersion");
    print("latestVersion $latestVersion");
    return _compareVersions(latestVersion, currentVersion);  // <--- COMPARE
  }

  bool _compareVersions(String latest, String current) {
    List<int> latestParts = latest.split('.').map(int.parse).toList();
    List<int> currentParts = current.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
        return true;
      } else if (latestParts[i] < currentParts[i]) {
        return false;
      }
    }
    return false;
  }
}
