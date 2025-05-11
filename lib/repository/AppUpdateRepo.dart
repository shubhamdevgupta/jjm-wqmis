import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/UpdateResponse.dart';
import '../services/BaseApiService.dart';
import '../utils/GlobalExceptionHandler.dart';

class Appupdaterepo extends ChangeNotifier {
  final BaseApiService _apiService = BaseApiService();

  Future<Updateresponse> fetchUpdateInfo() async {
    try {
      final response = await _apiService.get(
        'shubhamdevgupta/jjm-wqmis/contents/assets/update_info.json?ref=master&ts=${DateTime.now().millisecondsSinceEpoch}',
        apiType: ApiType.github,
      );

      // Get and clean the base64 content (remove newlines)
      final encodedContent = response['content'] as String;
      final cleanedContent = encodedContent.replaceAll('\n', '');

      // Decode and parse the JSON
      final decodedContent = utf8.decode(base64.decode(cleanedContent));
      final jsonData = json.decode(decodedContent);

      return Updateresponse.fromJson(jsonData);
    } catch (e) {
    print("update not working there");
      rethrow;
    }
  }


  Future<bool> isUpdateAvailable() async {
    try {
      final updateInfo = await fetchUpdateInfo();
      final currentVersion = await getCurrentAppVersion();

      print("currentVersion: $currentVersion");
      print("latestVersion: ${updateInfo.version}");

      return _compareVersions(updateInfo.version, currentVersion);
    } catch (_) {
      return false;
    }
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

  Future<String> getCurrentAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
