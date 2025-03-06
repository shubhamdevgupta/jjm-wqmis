// lib/providers/state_provider.dart

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/DistrictResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/GramPanchayatResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/HabitationResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/SchemeResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/StateResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/VillageResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WTPListResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceFilterResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/WaterSourceResponse.dart';
import 'package:jjm_wqmis/repository/MasterRepository.dart';

import '../models/MasterApiResponse/BlockResponse.dart';
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

  List<Wtplistresponse> wtpList = [];
  String? selectedWtp;

  List<Watersourcefilterresponse> wtsFilterList = [];
  String? selectedWtsfilter;

  int? _selectedSource;

  int? get selectedSource => _selectedSource;
  int? _selectedSubSource;

  int? get selectedSubSource => _selectedSubSource;
  int? _selectedPwsType;

  int? get selectedPwsType => _selectedPwsType;

  Masterprovider() {
    fetchStates();
  }

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
    isLoading = true;
    notifyListeners(); // Start loading
    try {
      districts = await _masterRepository.fetchDistricts(stateId);
      if (districts.isNotEmpty) {
        selectedDistrictId =
            districts.first.jJMDistrictId; // Default to first district
      }
    } catch (e) {
      debugPrint('Error in fetching districts: $e');
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

  Future<void> fetchGramPanchayat(
      String stateId, String districtId, String blockId) async {
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

  Future<void> fetchVillage(
      String stateId, String districtId, String blockId, String gpID) async {
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

  Future<void> fetchHabitations(String stateId, String districtId,
      String blockId, String gpId, String villageId) async {
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

  Future<void> fetchSchemes(String villageId, String habitationId) async {
    isLoading = true;
    notifyListeners();
    try {
      schemes = await _masterRepository.fetchSchemes(villageId, habitationId);
      if (schemes.isNotEmpty) {
        selectedScheme = schemes.first.schemeId;
      }
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

  Future<void> fetchWTPList(String villageId, String habitationId,
      String stateId, String schemeId) async {
    isLoading = true;
    try {
      wtpList = await _masterRepository.fetchWTPlist(
          villageId, habitationId, stateId, schemeId);
      if (wtpList.isNotEmpty) {
        selectedWtp = wtpList.first.wtpId;
      }
    } catch (e) {
      debugPrint('Error in fetching wtp list: $e');
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

  void setSelectedWaterSourcefilter(String? value) {
    selectedWtsfilter = value;
    notifyListeners(); // Notify listeners to rebuild the widget
  }

  void setSelectedWTP(String? value) {
    selectedWtp = value;
    notifyListeners(); // Notify listeners to rebuild the widget
  }

  void setSelectedWaterSourceInformation(String? value) {
    selectedWaterSource = value;
    notifyListeners(); // Notify listeners to rebuild the widget
  }

  void setSelectedSource(int? value) {
    _selectedSource = value;
    notifyListeners();
  }

  void setSelectedSubSource(int? value) {
    _selectedSubSource = value;
    notifyListeners();
  }

  void setSelectedPwsSource(int? value) {
    _selectedPwsType = value;
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
}
