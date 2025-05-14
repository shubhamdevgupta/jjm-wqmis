import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/utils/DataState.dart';

import '../models/SampleListResponse.dart';
import '../repository/SampleListRepo.dart';
import '../utils/GlobalExceptionHandler.dart';

class Samplelistprovider extends ChangeNotifier {
  final SampleListRepo _repository = SampleListRepo();

  DataState  dataState = DataState .initial;


 List<Sample> samples = []; // Correctly storing List<Sample>
  bool _isLoading = true;
  bool get isLoading => _isLoading;  String errorMsg='';

  Future<void> fetchSampleList(int regId, int page, String search, int cstatus, String sampleId, int stateid, int districtid, int blockid, int gpid, int villageid) async {
    _isLoading = true;
    notifyListeners();
    dataState = DataState .loading;
    try {

     final response = await _repository.fetchSampleList(regId, page, search, cstatus, sampleId, stateid, districtid, blockid, gpid, villageid);

     if(response.status==1){
       dataState = DataState .loaded;
       samples = response.result;
     }else{
       dataState = DataState .error;
       errorMsg=response.message;
     }


    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
