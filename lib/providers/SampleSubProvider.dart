import 'package:flutter/material.dart';

import '../models/SampleResponse.dart';
import '../repository/SampleSubRepo.dart';
import '../utils/DeviceUtils.dart';
import '../utils/GlobalExceptionHandler.dart';

class Samplesubprovider extends ChangeNotifier {
  final Samplesubrepo _samplesubrepo = Samplesubrepo();
  bool isSubmitData = false;
  Sampleresponse? sampleresponse;
  String errorMsg = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? deviceId = '';

  Future<void> sampleSubmit(
      Lab_id,
      Reg_Id,
      roldId,
      sample_collection_time,
      cat,
      sample_source_location,
      StateId,
      source_district,
      source_block,
      source_gp,
      source_village,
      source_habitation,
      source_filter,
      SchemeId,
      Other_Source_location,
      SourceName,
      latitude,
      longitude,
      sample_remark,
      IpAddress,
      sample_type_other,
      wtp_id,
      test_selected,
      sample_submit_type) async {
    _isLoading = true;
    notifyListeners();
    try {
      sampleresponse = await _samplesubrepo.sampleSubmit(
          Lab_id,
          Reg_Id,
          roldId,
          sample_collection_time,
          cat,
          sample_source_location,
          StateId,
          source_district,
          source_block,
          source_gp,
          source_village,
          source_habitation,
          source_filter,
          SchemeId,
          Other_Source_location,
          SourceName,
          latitude,
          longitude,
          sample_remark,
          IpAddress,
          sample_type_other,
          wtp_id,
          test_selected,
          sample_submit_type);
      if (sampleresponse!.status ==1) {
        isSubmitData = true;
        notifyListeners();
      } else {
        errorMsg = sampleresponse!.message;
      }
    } catch (e) {
      print("unhandeled exception-----$e");
      GlobalExceptionHandler.handleException(e as Exception);
      sampleresponse = null;
    } finally {
      _isLoading=false;
      notifyListeners();
    }
  }
  void fetchDeviceInfo() async {
    Map<String, dynamic> deviceInfo = await DeviceInfoUtil.getDeviceInfo();
    print(deviceInfo);
  }



}
