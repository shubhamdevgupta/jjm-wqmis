import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/SampleListResponse.dart';
import 'package:jjm_wqmis/repository/SampleListRepo.dart';
import 'package:jjm_wqmis/utils/custom_screen/GlobalExceptionHandler.dart';

class Samplelistprovider extends ChangeNotifier {
  final SampleListRepo _repository = SampleListRepo();

  List<Sample> samples = []; // Correctly storing List<Sample>
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  String errorMsg = '';
  bool hasMore = true;
  int PAGE = 1;

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
      if(sampleId.isNotEmpty){
        samples.clear();
      }  // if user is searching by id clear existing list
      final response = await _repository.fetchSampleList(regId, page, search,
          cstatus, sampleId, stateid, districtid, blockid, gpid, villageid);

      final List<Sample> currentSamples = List.from(samples);
      final List<Sample> newSamples = response.result;

      if (PAGE == 1) {
        currentSamples.clear();
      }
      currentSamples.addAll(newSamples);// Safely add new items

// Update the state once all modifications are done
      samples = currentSamples;

// Update pagination flags
      hasMore = newSamples.length >= 20; // Adjust to your backend's page size
      if (hasMore) PAGE++; // Increment only if there's more to fetch

// Handle status and messages
      _baseStatus = response.status;
      errorMsg = response.message;
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSample(
      String encSid,
      String? userId,
      String deviceId,
      Function(String response) onSuccess,
      Function(String error) onError) async {
    notifyListeners();
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
    // samples.removeAt(index);
    // notifyListeners();

    return false;
  }
}
