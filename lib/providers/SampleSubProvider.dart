import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/repository/AuthenticaitonRepository.dart';
import 'package:jjm_wqmis/utils/CustomException.dart';

import '../models/LoginResponse.dart';
import '../models/SampleResponse.dart';
import '../repository/SampleSubRepo.dart';
import '../services/LocalStorageService.dart';
import '../utils/GlobalExceptionHandler.dart';

class SubmitProvider extends ChangeNotifier {
  final Samplesubrepo _samplesubrepo = Samplesubrepo();
  bool _isSubmitData = false;
  Sampleresponse? _sampleresponse;
  String errorMsg = '';

  Future<void> SubmitData(
      Lab_id,
      Reg_Id,
      roldId,
      sample_collection_time,
      cat,
      sample_source_location,
      Function onFailure,
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
/*      _localStorage.saveBool('isLoggedIn', true);
      _localStorage.saveString('token', _loginResponse!.token.toString());*/
        notifyListeners();
        /*onSuccess();*/
      } else {
        errorMsg = _sampleresponse!.message;
        onFailure(errorMsg);
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      _sampleresponse = null;
    } finally {
      _isSubmitData = false;
      notifyListeners();
    }
  }
}
