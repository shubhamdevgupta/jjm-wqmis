import 'package:flutter/cupertino.dart';
import 'package:jjm_wqmis/models/FTK/ftk_dashboard_response.dart';
import 'package:jjm_wqmis/models/FTK/ftk_data_response.dart';
import 'package:jjm_wqmis/models/FTK/ftk_parameter_response.dart';
import 'package:jjm_wqmis/models/FTK/sample_response.dart';
import 'package:jjm_wqmis/repository/ftk_repository.dart';
import 'package:jjm_wqmis/utils/device_utils.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';

class Ftkprovider extends ChangeNotifier {
  final FtkRepository _ftkRepository = FtkRepository();

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  int selectedParam = 0;
  List<FtkParameter> ftkParameterList = [];
  String errorMessage = '';
  int baseStatus = 123;
  int? selectedValue; // Add this if not already present

  bool isSubmitData = false;
  Sampleresponse? sampleresponse;
  FtkDashboardResponse? ftkDashboardResponse;
  String errorMsg = '';

  String? _deviceId;
  String? get deviceId => _deviceId;

  List<FtkSample> ftkSample = []; // Correctly storing List<Sample>

  Future<void> fetchDeviceId() async {
    _deviceId = await DeviceInfoUtil.getUniqueDeviceId();
    debugPrint('Device ID: $_deviceId');
    notifyListeners();
  }

  Future<void> fetchParameterList(int stateId, int districtId,int regId) async {
    _isLoading = true;

    notifyListeners();
    try {
      final rawParamList =
          await _ftkRepository.fetchParameterList(stateId, districtId,regId);

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

  void setSelectedParamForIndex(int index, int selectedValue) {
    ftkParameterList[index].selectedValue = selectedValue;
    notifyListeners();
  }

  String getSelectedParameterIds() {
    return ftkParameterList
        .where((param) => param.selectedValue != null && param.selectedValue != 2)
        .map((param) => param.parameterId.toString())
        .join(',');
  }

  String getSelectedParameterValues() {
    return ftkParameterList
        .where((param) => param.selectedValue != null && param.selectedValue != 2)
        .map((param) => param.selectedValue.toString())
        .join(',');
  }


  Future<void> saveFtkData(
      mobileNumber,
      regId,
      roldId,
      sampleCollectionTime,
      sampleTestingTime,
      sourceId,
      sourceLocation,
      state,
      district,
      block,
      gramPanchayat,
      village,
      habitation,
      address,
      sampleRemark,
      waterSourceFilter,
      schemeId,
      otherSouceLocation,
      sourceName,
      latitude,
      longitude,
      ipAddress,
      sampleTypeOther,
      parameteId,
      paramSaferange) async {
    _isLoading = true;
    notifyListeners();
    try {
      sampleresponse = await _ftkRepository.saveFtkData(
          mobileNumber,
          regId,
          roldId,
          sampleCollectionTime,
          sampleTestingTime,
          sourceId,
          sourceLocation,
          state,
          district,
          block,
          gramPanchayat,
          village,
          habitation,
          address,
          sampleRemark,
          waterSourceFilter,
          schemeId,
          otherSouceLocation,
          sourceName,
          latitude,
          longitude,
          ipAddress,
          sampleTypeOther,
          parameteId,
          paramSaferange);
      notifyListeners();
      if (sampleresponse!.status == 1) {
        isSubmitData = true;
        notifyListeners();
      } else {
        errorMsg = sampleresponse!.message;
      }
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      sampleresponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchftkSampleList(
      int regId,
      int villageid,
      int sampleId
      ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _ftkRepository.fetchFtkSample(regId,villageid,sampleId);
      ftkSample = response.result;
      baseStatus = response.status;
      errorMsg = response.message;
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFtkDashboardData(
      int regId,
      int villageid,
      ) async {
    _isLoading = true;
    notifyListeners();

    try {
       ftkDashboardResponse = await _ftkRepository.fetchFtkDashboardData(regId,villageid);

      baseStatus = ftkDashboardResponse!.status;
      errorMsg = ftkDashboardResponse!.message;
    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, int> getSampleCountsMap() {
    final response = ftkDashboardResponse;

    if (response == null) return {};

    return {
      // These keys MUST match wtsFilterList's source.id values
      "2": response.totalSourceScheme,
      "6": response.totalStorageStructure,
      "3": response.totalHhScAwc,
      "4": response.totalHandpumpsOtherPrivateSource,
    };
  }





}
