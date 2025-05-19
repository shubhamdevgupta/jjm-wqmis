import 'package:flutter/cupertino.dart';

import '../models/SampleListResponse.dart';
import '../repository/SampleListRepo.dart';
import '../utils/DeviceUtils.dart';
import '../utils/GlobalExceptionHandler.dart';

class Samplelistprovider extends ChangeNotifier {
  final SampleListRepo _repository = SampleListRepo();

  List<Sample> samples = []; // Correctly storing List<Sample>
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  String errorMsg = '';

  int _baseStatus = 0;

  int get baseStatus => _baseStatus;

  Future<void> fetchSampleList(
      int regId,
      int page,
      String search,
      int cstatus,
      String sampleId,
      int stateid,
      int districtid,
      int blockid,
      int gpid,
      int villageid) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.fetchSampleList(regId, page, search,
          cstatus, sampleId, stateid, districtid, blockid, gpid, villageid);
      samples = response.result;
      _baseStatus = response.status;
      errorMsg = response.message;
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSample(String encSid, String? userId, String deviceId, Function(String response) onSuccess,
      Function(String error) onError) async {
    _isLoading = true;
  //  notifyListeners();
    try {

      final response = await _repository.deleteSample(encSid, userId, deviceId);

      _baseStatus = response.status;
      errorMsg = response.message;

      if (response.status == 1) {
        onSuccess(response.message);
      } else {
        onError(response.message);
      }

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool deleteSampleFromList(int index, int targetSId) {

    bool exists = samples.any((sample) => sample.sId == targetSId);
    if (exists) {
      samples.removeWhere((sample) => sample.sId == targetSId);
      notifyListeners();
      return true;
    }
    // samples.removeWhere((sample) => sample.sId == targetSId);
    // samples.removeAt(index);
    // notifyListeners();

    return false;


  }
}
