import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/SampleListResponse.dart';
import 'package:jjm_wqmis/models/SampleResponse.dart';
import 'package:jjm_wqmis/repository/SampleListRepo.dart';
import '../utils/GlobalExceptionHandler.dart';

class Samplelistprovider extends ChangeNotifier {
  final SampleListRepo _repository=SampleListRepo();

  List<Samplelistresponse> samples = [];
  bool isLoading = false;


  Future<void> fetchSampleList(int regId, int page,String search, int cstatus, int sampleId) async {
    print('Calling the sample list function...');
    isLoading = true;
    notifyListeners();

    try {
      samples = await _repository.fetchSampleList(regId, page,search, cstatus, sampleId);
    } catch (e) {
      debugPrint('Error in SampleProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }
}
