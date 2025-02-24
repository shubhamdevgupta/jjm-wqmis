// lib/providers/state_provider.dart

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/DistrictResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/GramPanchayatResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/HabitationResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/StateResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/VillageResponse.dart';
import 'package:jjm_wqmis/repository/MasterRepository.dart';

import '../models/MasterApiResponse/BlockResponse.dart';

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

  List<VillageResponse> village = [];
  String? selectedVillage;

  List<HabitationResponse> habitationId = [];
  String? selectedHabitation;

  Masterprovider() {
    fetchStates();
  }

  Future<void> fetchStates() async {
    print('callinng the state functionnnnn');
    isLoading = true;
    notifyListeners(); // Start loading
    try {
      states = await _masterRepository.fetchStates();
      if (states.isNotEmpty) {
        selectedStateId = states.first.jjmStateId; // Default to the first state
      }
    } catch (e) {
      debugPrint('Error in StateProvider: $e');
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
      debugPrint('Error in fetching blocks: $e');
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
        selectedVillage = village.first.villageName;
      }
    } catch (e) {
      debugPrint('Error in fetching blocks: $e');
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
        selectedHabitation = habitationId.first.habitationName;
      }
    } catch (e) {
      debugPrint('Error in fetching blocks: $e');
    } finally {
      isLoading = false;
      notifyListeners(); // Finish loading
    }
  }

  void setSelectedHabitation(String? habitationId) {
    selectedHabitation = habitationId;
    notifyListeners();
  }

  void setSelectedVillage(String? village) {
    selectedVillage = village;
    selectedHabitation = null;
    habitationId.clear();
    notifyListeners();
  }

  void setSelectedGrampanchayat(String? grampanchayat) {
    selectedGramPanchayat = grampanchayat;
    selectedVillage = null;
    selectedHabitation=null;
    habitationId.clear();
    notifyListeners();
  }

  void setSelectedBlock(String? blockId) {
    selectedBlockId = blockId;
    selectedGramPanchayat = null;
    selectedVillage = null;
    selectedHabitation = null;
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
    districts.clear(); // Clear districts when state changes
    blocks.clear(); // Clear blocks when state changes
    gramPanchayat.clear();
    village.clear();
    habitationId.clear();
    notifyListeners();
  }
}
