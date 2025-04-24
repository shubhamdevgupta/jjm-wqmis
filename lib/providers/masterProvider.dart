// lib/providers/state_provider.dart

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/DistrictResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/GramPanchayatResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/HabitationResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/SchemeResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/StateResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/VillageResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceFilterResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceResponse.dart';
import 'package:jjm_wqmis/models/Wtp/WTPListResponse.dart';
import 'package:jjm_wqmis/models/Wtp/WtpLabResponse.dart';
import 'package:jjm_wqmis/repository/MasterRepository.dart';

import '../models/LgdResponse.dart';
import '../models/MasterApiResponse/BlockResponse.dart';
import '../models/ValidateVillage.dart';
import '../repository/LapParameterRepository.dart';
import '../utils/GlobalExceptionHandler.dart';

class Masterprovider extends ChangeNotifier {
  final MasterRepository _masterRepository = MasterRepository();

  List<Stateresponse> states = [];
  bool isLoading = false;
  String? selectedStateId;

  List<Districtresponse> districts = [];
  String? selectedDistrictId;

  List<BlockResponse> blocks = [];
  String? selectedBlockId;

  List<GramPanchayatresponse> gramPanchayat = [];
  String? selectedGramPanchayat;

  List<Villageresponse> village = [];
  String? selectedVillage;

  List<HabitationResponse> habitationId = [];
  String? selectedHabitation;

  List<SchemeResponse> schemes = [];
  String? selectedScheme;

  List<WaterSourceResponse> waterSource = [];
  String? selectedWaterSource;

  List<Wtp> wtpList = [];
  String? selectedWtp;

  List<Watersourcefilterresponse> wtsFilterList = [];
  String? selectedWtsfilter;

  List<Lgdresponse> _villageDetails =
      []; // Update to a List instead of a single object
  List<Lgdresponse> get villageDetails => _villageDetails;

  ValidateVillageResponse? _validateVillageResponse;

  ValidateVillageResponse? get validateVillageResponse =>
      _validateVillageResponse;

  int? _selectedSubSource;

  int? get selectedSubSource => _selectedSubSource;

  int? _selectedHouseHoldType;

  int? get selectedHousehold => _selectedHouseHoldType;

  int? _selectedHandpumpPrivate;

  int? get selectedHandpumpPrivate => _selectedHandpumpPrivate;

  String? _selectedDatetime = "";

  String? get selectedDatetime => _selectedDatetime;

  String errorMsg = '';
  String otherSourceLocation = '';
  String sampleTypeOther = '';

  Future<void> fetchStates() async {
    print('Calling the state function...');
    isLoading = true;
    notifyListeners();
    try {
      final basestates = await _masterRepository.fetchStates();
      if (basestates.status == 1) {
        states = basestates.result;
      } else {
        errorMsg = basestates.message;
      }
    } catch (e) {
      debugPrint('Error in StateProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDistricts(String stateId) async {
    print('Fetching districts for state: $stateId');
    setSelectedState(stateId);
    isLoading = true;
    notifyListeners();

    try {
      final rawDistricts = await _masterRepository.fetchDistricts(stateId);
      if (rawDistricts.status == 1) {
        districts = rawDistricts.result;
      } else {
        errorMsg = rawDistricts.message;
      }
    } catch (e) {
      debugPrint('Error in fetching districts: master provider $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load districts.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBlocks(String stateId, String districtId) async {
    if (stateId.isEmpty || districtId.isEmpty) {
      errorMsg = "Please select both State and District.";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final rawBlocks =
          await _masterRepository.fetchBlocks(stateId, districtId);

      if (rawBlocks.status == 1) {
        blocks = rawBlocks.result;
      } else {
        errorMsg = rawBlocks.message;
      }
    } catch (e) {
      debugPrint('Error in fetching blocks: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load blocks.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGramPanchayat(
      String stateId, String districtId, String blockId) async {
    if (stateId.isEmpty || districtId.isEmpty || blockId.isEmpty) {
      errorMsg = "Please select State, District, and Block.";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final rawGPs = await _masterRepository.fetchGramPanchayats(
          stateId, districtId, blockId);

      if (rawGPs.status == 1) {
        gramPanchayat = rawGPs.result;
      } else {
        errorMsg = rawGPs.message;
      }
    } catch (e) {
      debugPrint('Error in fetching grampanchayat: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load Gram Panchayats.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVillage(
      String stateId, String districtId, String blockId, String gpID) async {
    if (stateId.isEmpty ||
        districtId.isEmpty ||
        blockId.isEmpty ||
        gpID.isEmpty) {
      errorMsg = "Please select all required fields.";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final rawVillages = await _masterRepository.fetchVillages(
          stateId, districtId, blockId, gpID);

      if (rawVillages.status == 1) {
        village = rawVillages.result;
        if (village.length == 1) {
          selectedVillage = village.first.jjmVillageId.toString();
        }
      } else {
        errorMsg = rawVillages.message;
      }
    } catch (e) {
      debugPrint('Error in fetching village: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load villages.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHabitations(String stateId, String districtId,
      String blockId, String gpId, String villageId) async {
    if ([stateId, districtId, blockId, gpId, villageId].any((e) => e.isEmpty)) {
      errorMsg = "Please select all fields to load habitations.";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final rawHabitations = await _masterRepository.fetchHabitations(
          stateId, districtId, blockId, gpId, villageId);

      if (rawHabitations.status == 1) {
        habitationId = rawHabitations.result;
        if (habitationId.length == 1) {
          selectedHabitation = habitationId.first.habitationId.toString();
        }
      } else {
        errorMsg = rawHabitations.message;
      }
    } catch (e) {
      debugPrint('Error in fetching habitation: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load habitations.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSchemes(String villageId, String habitationId,
      String districtid, String filter) async {
    isLoading = true;
    notifyListeners();
    try {
      final mSchemes = await _masterRepository.fetchSchemes(
          villageId, habitationId, districtid, filter);

      if (mSchemes.status == 1) {
        schemes = mSchemes.result;
        if (schemes.length == 1) {
          selectedScheme = schemes.first.schemeId.toString();
        }
      } else {
        errorMsg = mSchemes.message;
      }
        // 🔁 Trigger the dependent API when auto-selected
        if (selectedWtsfilter == "5") {
          await fetchWTPList(selectedStateId!, selectedScheme!);
        } else if (selectedWtsfilter == "6") {
          setSelectedSubSource(0);
          setSelectedWTP("0");
          await fetchSourceInformation(
            selectedVillage!,
            selectedHabitation!,
            selectedWtsfilter!,
            "0",
            selectedSubSource.toString(),
            selectedWtp!,
            selectedStateId!,
            selectedScheme!,
          );
        }
    } catch (e) {
      debugPrint('Error in fetching scheme: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSourceInformation(
    String villageId,
    String habitationId,
    String filter,
    String cat,
    String subcat,
    String wtpId,
    String stateId,
    String schemeId,
  ) async {
    isLoading = true;
    try {
     final rawWaterSource = await _masterRepository.fetchSourceInformation(villageId,
          habitationId, filter, cat, subcat, wtpId, stateId, schemeId);

      if(rawWaterSource.status==1){
        waterSource=rawWaterSource.result;
        if (waterSource.length == 1) {
          selectedWaterSource = waterSource.first.locationId.toString();
        }
      }else{
        errorMsg=rawWaterSource.message;
      }


 /*     if (waterSource.isNotEmpty) {
        // Case: Only 1 item + --Select-- and it's valid (not '0')
        if (waterSource.length == 2 && waterSource[1].locationId != "0") {
          selectedWaterSource = waterSource[1].locationId;
        }
        // Case: Only 1 item + --Select-- and it's 'Data Not Available'
        else if (waterSource.length == 2 && waterSource[1].locationId == "0") {
          selectedWaterSource = "0";
        }
        // Case: Only 1 item in list and it's 'Data Not Available'
        else if (waterSource.length == 1 && waterSource[0].locationId == "0") {
          selectedWaterSource = "0";
        } else {
          selectedWaterSource = null;
        }
      } else {
        selectedWaterSource = null;
      }*/
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWTPList(String stateId, String schemeId) async {
    isLoading = true;
    notifyListeners();
    try {
      final fetchedList =
          await _masterRepository.fetchWTPlist(stateId, schemeId);

      if (fetchedList.isNotEmpty) {
        wtpList = fetchedList;

        if (wtpList.length == 1 && wtpList.first.wtpId == "0") {
          // Case: Only one item and it's "Data Not Available"
          selectedWtp = "0";
        } else if (wtpList.length == 2 && wtpList[1].wtpId != 0) {
          // Case: Only one valid item, auto-select it
          selectedWtp = wtpList[1].wtpId;
        } else if (wtpList.length == 2 && wtpList[1].wtpId == "0") {
          // Case: Two items and second one is "Data Not Available"
          selectedWtp = "0";
        } else {
          // General case: Check if current selection is still valid
          if (wtpList.any((wtp) => wtp.wtpId == selectedWtp)) {
            selectedWtp = selectedWtp;
          } else {
            selectedWtp = null; // Let the user select
          }
        }
      } else {
        selectedWtp = null;
        wtpList = [];
      }
    } catch (e) {
      debugPrint('Error in fetching WTP list: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWatersourcefilterList() async {
    isLoading = true;
    notifyListeners(); // Start loading
    try {
     final rawWtsFilterList = await _masterRepository.fetchWaterSourceFilterList();
    if(rawWtsFilterList.status==1){
      wtsFilterList=rawWtsFilterList.result;
    }else{
      errorMsg=rawWtsFilterList.message;
    }

    } catch (e) {
      debugPrint('Error in StateProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }

  Future<void> fetchVillageDetails(double lon, double lat) async {
    isLoading = true;
    errorMsg = "";
    notifyListeners();

    try {
      String formattedLon = lon.toStringAsFixed(8);
      String formattedLat = lat.toStringAsFixed(8);

      _villageDetails = await _masterRepository.fetchVillageLgd(
        double.parse(formattedLon),
        double.parse(formattedLat),
      );

      if (_villageDetails.isEmpty) {
        errorMsg = "No village details found.";
      }
    } catch (e) {
      debugPrint('Error in fetchVillageDetails: $e');
      errorMsg = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> validateVillage(String villageId, String lgdCode) async {
    isLoading = true;
    errorMsg = "";
    notifyListeners();
    try {
      _validateVillageResponse =
          await _masterRepository.validateVillage(villageId, lgdCode);
    } catch (e) {
      errorMsg = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch WTP Labs from API

  void setSelectedDateTime(String? value) {
    _selectedDatetime = value;
    notifyListeners();
  }

  void setSelectedWaterSourcefilter(String? value) {
    selectedWtsfilter = value;
    _selectedSubSource = null;
    _selectedHouseHoldType = null;
    _selectedHandpumpPrivate = null;

    selectedWtp = null;
    selectedScheme = null;
    notifyListeners(); // Notify listeners to rebuild the widget
  }

  void setSelectedHouseHold(int? value) {
    _selectedHouseHoldType = value;
    notifyListeners();
  }

  void setSelectedHandpump(int? value) {
    _selectedHandpumpPrivate = value;
    notifyListeners();
  }

  void setSelectedWTP(String? value) {
    selectedWtp = value;
    notifyListeners(); // Notify listeners to rebuild the widget
  }

  void setSelectedWaterSourceInformation(String? value) {
    selectedWaterSource = value;
    notifyListeners(); // Notify listeners to rebuild the widget
  }

  void setSelectedSubSource(int? value) {
    _selectedSubSource = value;
    waterSource=[];
    selectedWaterSource='';
    notifyListeners();
  }

  void setSelectedScheme(String? schemeId) {
    selectedScheme = schemeId;
    notifyListeners();
  }

  void setSelectedHabitation(String? habitationId) {
    selectedHabitation = habitationId;
    notifyListeners();
  }

  void setSelectedVillage(String? village) {
    selectedVillage = village;
    selectedHabitation = null;
    selectedScheme = null;
    schemes.clear();
    habitationId.clear();
    notifyListeners();
  }

  void setSelectedGrampanchayat(String? grampanchayat) {
    selectedGramPanchayat = grampanchayat;
    selectedVillage = null;
    selectedHabitation = null;
    selectedScheme = null;
    schemes.clear();
    habitationId.clear();
    notifyListeners();
  }

  void setSelectedBlock(String? blockId) {
    selectedBlockId = blockId;
    selectedGramPanchayat = null;
    selectedVillage = null;
    selectedHabitation = null;
    selectedScheme = null;
    schemes.clear();
    gramPanchayat.clear();
    village.clear();
    habitationId.clear();
    notifyListeners();
  }

  void setSelectedDistrict(String? districtId) {
    selectedDistrictId = districtId;
    selectedBlockId = null;
    selectedGramPanchayat = null;
    selectedVillage = null;
    selectedHabitation = null;
    selectedScheme = null;
    schemes.clear();
    blocks.clear(); // Clear blocks when district changes
    gramPanchayat.clear();
    habitationId.clear();
    village.clear();
    notifyListeners();
  }

  void setSelectedState(String? stateId) {
    selectedStateId = stateId;
    selectedDistrictId = null;
    selectedBlockId = null;
    selectedGramPanchayat = null;
    selectedVillage = null;
    selectedHabitation = null;
    selectedScheme = null;
    schemes.clear();
    districts.clear(); // Clear districts when state changes
    blocks.clear(); // Clear blocks when state changes
    gramPanchayat.clear();
    village.clear();
    habitationId.clear();
    notifyListeners();
  }

  void clearData() {
    states.clear();
    isLoading = false;
    selectedStateId = null;

    districts.clear();
    selectedDistrictId = null;

    blocks.clear();
    selectedBlockId = null;

    gramPanchayat.clear();
    selectedGramPanchayat = null;

    village.clear();
    selectedVillage = null;

    habitationId.clear();
    selectedHabitation = null;

    schemes.clear();
    selectedScheme = null;

    waterSource.clear();
    selectedWaterSource = null;

    wtpList.clear();
    selectedWtp = null;

    wtsFilterList.clear();
    selectedWtsfilter = null;

    _villageDetails.clear();

    _validateVillageResponse = null;

    notifyListeners();
  }
}
