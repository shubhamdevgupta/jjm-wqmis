// lib/providers/state_provider.dart

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/DistrictResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/GramPanchayatResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/HabitationResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/SchemeResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/StateResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/VillageResponse.dart';
import 'package:jjm_wqmis/models/Wtp/WTPListResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceFilterResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceResponse.dart';
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

  List<Lgdresponse> _villageDetails = []; // Update to a List instead of a single object
  List<Lgdresponse> get villageDetails => _villageDetails;

  bool isWtp=false;

  ValidateVillageResponse? _validateVillageResponse;
  ValidateVillageResponse? get validateVillageResponse => _validateVillageResponse;

  WtpLabResponse? _wtpLabModel;
  WtpLabResponse? get wtpLabModel => _wtpLabModel;

  List<WtpLab>  wtpLab =[];
  String? selectedWtpLab;

  int? _selectedSubSource;

  int? get selectedSubSource => _selectedSubSource;

  int? _selectedHouseHoldType;

  int? get selectedHousehold => _selectedHouseHoldType;

  int? _selectedHandpumpPrivate;

  int? get selectedHandpumpPrivate => _selectedHandpumpPrivate;

  String? _selectedDatetime="";

  String? get selectedDatetime => _selectedDatetime;

  String errorMsg = '';
  String otherSourceLocation = '';
  String sampleTypeOther = '';

  Future<void> fetchStates() async {
    print('Calling the state function...');
    isLoading = true;
    notifyListeners(); // Start loading

    try {
      states = await _masterRepository.fetchStates();
      if (states.isNotEmpty) {
        selectedStateId = states.first.jjmStateId; // Default to the first state
      }
    } catch (e) {
      debugPrint('Error in StateProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }

  Future<void> fetchDistricts(String stateId) async {
    print('Fetching districts for state: $stateId');
    setSelectedState(stateId);
    isLoading = true;
    notifyListeners(); // Start loading
    try {
      districts = await _masterRepository.fetchDistricts(stateId);
      if (districts.isNotEmpty) {
        selectedDistrictId =
            districts.first.jJMDistrictId; // Default to first district
      }
    } catch (e) {
      debugPrint('Error in fetching districts: master provider  $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }

  Future<void> fetchBlocks(String stateId, String districtId) async {
    isLoading = true;
    notifyListeners(); // Start loading
    try {
      blocks = await _masterRepository.fetchBlocks(stateId, districtId);
      if (blocks.isNotEmpty) {
        selectedBlockId = blocks.first.jjmBlockId;
      }
    } catch (e) {
      debugPrint('Error in fetching blocks: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }

  Future<void> fetchGramPanchayat(String stateId, String districtId, String blockId) async {
    isLoading = true;
    notifyListeners(); // Start loading
    try {
      gramPanchayat = await _masterRepository.fetchGramPanchayats(
          stateId, districtId, blockId);
      if (gramPanchayat.isNotEmpty) {
        selectedGramPanchayat = gramPanchayat.first.jjmPanchayatId;
      }
    } catch (e) {
      debugPrint('Error in fetching grampanchayat: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }

  Future<void> fetchVillage(String stateId, String districtId, String blockId, String gpID) async {
    isLoading = true;
    notifyListeners(); // Start loading
    try {
      village = await _masterRepository.fetchVillages(
          stateId, districtId, blockId, gpID);
      if (village.isNotEmpty) {
        selectedVillage = village.first.jjmVillageId.toString();
      }
    } catch (e) {
      debugPrint('Error in fetching village: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }

  Future<void> fetchHabitations(String stateId, String districtId, String blockId, String gpId, String villageId) async {
    isLoading = true;
    notifyListeners();
    try {
      habitationId = await _masterRepository.fetchHabitations(
          stateId, districtId, blockId, gpId, villageId);
      if (habitationId.isNotEmpty) {
        selectedHabitation = habitationId.first.habitationId.toString();
      }
    } catch (e) {
      debugPrint('Error in fetching habitation: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }

  Future<void> fetchSchemes(String villageId, String habitationId, String districtid, String filter) async {
    isLoading = true;
    notifyListeners();
    try {
      schemes = await _masterRepository.fetchSchemes(
          villageId, habitationId, districtid,filter);

      List<SchemeResponse> filteredSchemes = [
        SchemeResponse(schemeId: "", schemeName: "--Select--")
      ];
      filteredSchemes.addAll(
          schemes.where((scheme) => scheme.schemeId.isNotEmpty).toList());
      if (filteredSchemes.length > 1) {
        print('Valid schemes found');
        selectedScheme =
            filteredSchemes.first.schemeId; // Select "Select" by default
      } else {
        print('No valid scheme found, updating list to "Data Not Available"');
        filteredSchemes = [
          SchemeResponse(schemeId: "0", schemeName: "Data Not Available")
        ];
        selectedScheme = filteredSchemes.first.schemeId;
      }

      schemes = filteredSchemes; // Update the provider list
      notifyListeners();
    } catch (e) {
      debugPrint('Error in fetching scheme: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
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
      String schemeId) async {
    isLoading = true;
    try {
      waterSource = await _masterRepository.fetchSourceInformation(villageId,
          habitationId, filter, cat, subcat, wtpId, stateId, schemeId);
      if (waterSource.isNotEmpty) {
        selectedWaterSource = waterSource.first.locationId;
      }
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWTPList( String stateId, String schemeId) async {
    isLoading = true;
    notifyListeners();
    try {
      final fetchedList = await _masterRepository.fetchWTPlist(stateId, schemeId);

      if (fetchedList.isNotEmpty) {
        wtpList = fetchedList;

        // Ensure a valid default value is set
        if (wtpList.any((wtp) => wtp.wtpId == selectedWtp)) {
          selectedWtp = selectedWtp; // Keep the existing if valid
        } else {
          selectedWtp = wtpList.first.wtpId; // Reset if invalid
        }
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
      wtsFilterList = await _masterRepository.fetchWaterSourceFilterList();
      if (wtsFilterList.isNotEmpty) {
        wtsFilterList.insert(
            0, Watersourcefilterresponse(id: 0, sourceType: "-Select-"));
        selectedWtsfilter =
            wtsFilterList.first.id.toString(); // Default to the first state
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
      _validateVillageResponse = await _masterRepository.validateVillage(villageId, lgdCode);
    } catch (e) {
      errorMsg = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch WTP Labs from API
  Future<void> fetchWTPLab(String stateId, String wtpId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _masterRepository.fetchWtpLabs(stateId, wtpId);

      if (response != null) {
        _wtpLabModel = response;

        if (_wtpLabModel!.status == 1) {
          wtpLab = _wtpLabModel!.result;

          if (wtpLab.any((wtp) => wtp.labId == selectedWtpLab)) {
            selectedWtpLab = selectedWtpLab; // Keep current selected if still valid
          } else if (wtpLab.isNotEmpty) {
            selectedWtpLab = wtpLab.first.labId; // Reset if invalid or select first
          } else {
            selectedWtpLab = ''; // Handle if list is empty
          }
        } else {
          debugPrint("API Message: ${_wtpLabModel!.message}");
          _wtpLabModel = WtpLabResponse(
            status: 0,
            message: _wtpLabModel!.message,
            result: [], // Ensure empty labs list
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching WTP Labs: $e");
      _wtpLabModel = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  void setSelectedDateTime(String? value) {
    _selectedDatetime = value;
    notifyListeners();
  }

  void setSelectedWaterSourcefilter(String? value) {
    selectedWtsfilter = value;
    _selectedSubSource = null;
    _selectedHouseHoldType = null;
    _selectedHandpumpPrivate = null;

    selectedWtp=null;
    selectedScheme=null;
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

    isWtp = false;

    _validateVillageResponse = null;

    _wtpLabModel = null;

    wtpLab.clear();

    notifyListeners();
  }

}
