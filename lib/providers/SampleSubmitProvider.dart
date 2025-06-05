import 'package:flutter/material.dart';

import 'package:jjm_wqmis/models/SampleResponse.dart';
import 'package:jjm_wqmis/repository/SampleSubRepo.dart';
import 'package:jjm_wqmis/utils/DeviceUtils.dart';
import 'package:jjm_wqmis/utils/GlobalExceptionHandler.dart';

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
          latitude,
          longitude,
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
    } catch (e) {
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


}
