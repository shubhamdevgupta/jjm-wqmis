import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/repository/FtkRepository.dart';

import 'package:jjm_wqmis/models/FTK/FtkParameterResponse.dart';
import 'package:jjm_wqmis/utils/GlobalExceptionHandler.dart';

class Ftkprovider extends ChangeNotifier {
  final FtkRepository _ftkRepository = FtkRepository();

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<FtkParameter> ftkParameterList = [];
  String errorMessage = '';
  int baseStatus = 101;

  Future<void> fetchParameterList(
      int stateId, int districtId,) async {
    _isLoading = true;

    notifyListeners();
    try {
      final rawParamList =
          await _ftkRepository.fetchParameterList(stateId, districtId);

      if (rawParamList.status == 1) {
        ftkParameterList = rawParamList.result;
      } else {
        errorMessage = rawParamList.message;
      }
      baseStatus = rawParamList.status;
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
