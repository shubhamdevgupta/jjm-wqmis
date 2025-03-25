import 'package:flutter/cupertino.dart';

import '../models/SampleListResponse.dart';
import '../repository/SampleListRepo.dart';
import '../utils/GlobalExceptionHandler.dart';

class Samplelistprovider extends ChangeNotifier {
  final SampleListRepo _repository = SampleListRepo();

  int status = 0;
  String message = '';
  List<Sample> samples = []; // Correctly storing List<Sample>
  bool isLoading = false;

  Future<void> fetchSampleList(int regId, int page, String search, int cstatus, String sampleId, int stateid, int districtid, int blockid, int gpid, int villageid) async {
    print('Fetching full sample response...');
    isLoading = true;
    notifyListeners();

    try {
      // Get the FULL response
      Samplelistresponse response = await _repository.fetchSampleList(regId, page, search, cstatus, sampleId, stateid, districtid, blockid, gpid, villageid);

      // Store status and message
      status = response.status;
      message = response.message;

      // ✅ Extract the `result` list correctly
      samples = response.result; // `result` is already `List<Sample>`

      print('Status: $status, Message: $message');
      print('Samples updated in provider: ${samples.length} items');
    } catch (e) {
      debugPrint('Error in SampleProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
