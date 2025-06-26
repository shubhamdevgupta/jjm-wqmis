import 'package:flutter/material.dart';

import 'package:jjm_wqmis/models/FTK/SampleResponse.dart';
import 'package:jjm_wqmis/repository/SampleSubRepo.dart';
import 'package:jjm_wqmis/utils/DeviceUtils.dart';
import 'package:jjm_wqmis/utils/custom_screen/GlobalExceptionHandler.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class Samplesubprovider extends ChangeNotifier {
  final Samplesubrepo _samplesubrepo = Samplesubrepo();
  bool isSubmitData = false;
  Sampleresponse? sampleresponse;
  String errorMsg = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _deviceId;
  String? get deviceId => _deviceId;

  Future<void> sampleSubmit(
      labId,
      regId,
      roldId,
      sampleCollectionTime,
      cat,
      sampleSourceLocation,
      StateId,
      sourceDistrict,
      sourceBlock,
      sourceGp,
      sourceVillage,
      sourceHabitation,
      sourceFilter,
      SchemeId,
      otherSourceLocation,
      SourceName,
      latitude,
      longitude,
      sampleRemark,
      IpAddress,
      sampleTypeOther,
      wtpId,
      istreated,
      testSelected,
      sampleSubmitType) async {
    _isLoading = true;
    notifyListeners();
    try {
      sampleresponse = await _samplesubrepo.sampleSubmit(
          labId,
          regId,
          roldId,
          sampleCollectionTime,
          cat,
          sampleSourceLocation,
          StateId,
          sourceDistrict,
          sourceBlock,
          sourceGp,
          sourceVillage,
          sourceHabitation,
          sourceFilter,
          SchemeId,
          otherSourceLocation,
          SourceName,
          latitude.toString(),
          longitude.toString(),
          sampleRemark,
          IpAddress,
          sampleTypeOther,
          wtpId,
          istreated,
          testSelected,
          sampleSubmitType);
      notifyListeners();
      if (sampleresponse!.status ==1) {
        isSubmitData = true;
        notifyListeners();
      } else {
        errorMsg = sampleresponse!.message;
      }
    } catch (e,stackTrace) {
      print("Caught error: $e :: $stackTrace");
      GlobalExceptionHandler.handleException(e as Exception);
      sampleresponse = null;

    } finally {
      _isLoading=false;
      notifyListeners();
    }
  }
  Future<void> fetchDeviceId() async {
    _deviceId = await DeviceInfoUtil.getUniqueDeviceId();
    debugPrint('Device ID: $_deviceId');
    notifyListeners();
  }


  double? _latitude;
  double? _longitude;

  // ✅ Getters
  double? get lat => _latitude;
  double? get lng => _longitude;

  // ✅ Optional helper method
  void setLocation(double? lat, double? lng) {
    _latitude = lat;
    _longitude = lng;
    notifyListeners();
  }


  Future<void> checkAndPromptLocation(BuildContext context) async {
    _isLoading = true;

    final status = await Permission.location.request();

    if (status.isGranted) {
      Location location = Location();

      // Check if GPS is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _isLoading=false;
          // Show dialog if user still refuses
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Enable Location"),
              content: const Text("GPS is required to fetch location."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    await openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Open Settings"),
                ),
              ],
            ),
          );
          return;
        }
      }

      // ✅ Now GPS is ON and permission is granted
      LocationData locationData = await location.getLocation();

      setLocation(locationData.latitude, locationData.longitude);
      _isLoading=false;
      print("Lat: $_latitude, Lng: $_longitude");

    } else {
      _isLoading=false;
      // Permission denied
      await openAppSettings();
    }
  }

}