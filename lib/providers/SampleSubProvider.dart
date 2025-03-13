import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/SampleResponse.dart';
import '../repository/SampleSubRepo.dart';
import '../utils/GlobalExceptionHandler.dart';
import '../utils/LocationUtils.dart';

class Samplesubprovider extends ChangeNotifier {
  final Samplesubrepo _samplesubrepo = Samplesubrepo();
  bool _isSubmitData = false;
  Sampleresponse? _sampleresponse;
  String errorMsg = '';

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String latitude = '';
  String longitude = '';
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
      _sampleresponse = await _samplesubrepo.sampleSubmit(
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
      if (_sampleresponse?.status == 1) {
        _isSubmitData = true;
        notifyListeners();
      } else {
        errorMsg = _sampleresponse!.message;
      }
    } catch (e) {
      print("unhandeled exception-----$e");
      GlobalExceptionHandler.handleException(e as Exception);
      _sampleresponse = null;
    } finally {
      _isLoading=false;
      _isSubmitData = false;
      notifyListeners();
    }
  }



}
