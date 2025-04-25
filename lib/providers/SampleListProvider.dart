import 'package:flutter/cupertino.dart';

import '../models/SampleListResponse.dart';
import '../repository/SampleListRepo.dart';
import '../utils/GlobalExceptionHandler.dart';

class Samplelistprovider extends ChangeNotifier {
  final SampleListRepo _repository = SampleListRepo();


 List<Sample> samples = []; // Correctly storing List<Sample>
  bool isLoading = false;
  String errorMsg='';

  Future<void> fetchSampleList(int regId, int page, String search, int cstatus, String sampleId, int stateid, int districtid, int blockid, int gpid, int villageid) async {
    print('Fetching full sample response...');
    isLoading = true;
    notifyListeners();

    try {

     final response = await _repository.fetchSampleList(regId, page, search, cstatus, sampleId, stateid, districtid, blockid, gpid, villageid);
     samples = response.result; // `result` is already `List<Sample>`

     errorMsg=response.message;
      print('Status: ${response.status}, Message: ${response.message}');
      print('Samples updated in provider: ${response.result.length} items');
    } catch (e) {
      debugPrint('Error in SampleProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void reset() {
    // TODO: implement reset
  }
}
