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
import 'package:jjm_wqmis/repository/MasterRepository.dart';
import 'package:jjm_wqmis/utils/DataState.dart';

import '../models/LgdResponse.dart';
import '../models/MasterApiResponse/BlockResponse.dart';
import '../models/ValidateVillage.dart';
import '../services/LocalStorageService.dart';
import '../utils/AppConstants.dart';
import '../utils/CurrentLocation.dart';
import '../utils/GlobalExceptionHandler.dart';
import '../utils/LocationUtils.dart';

class Masterprovider extends ChangeNotifier {
  final MasterRepository _masterRepository = MasterRepository();

  List<Stateresponse> states = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;
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


  double? _currentLatitude;
  double? _currentLongitude;

  double? get currentLatitude => _currentLatitude;

  double? get currentLongitude => _currentLongitude;

  List<Watersourcefilterresponse> wtsFilterList = [];
  String? selectedWtsfilter;

  List<Lgdresponse> _villageDetails =
      []; // Update to a List instead of a single object
  List<Lgdresponse> get villageDetails => _villageDetails;

  ValidateVillageResponse? _validateVillageResponse;

  ValidateVillageResponse? get validateVillageResponse =>
      _validateVillageResponse;

  int baseStatus = 0;
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
  final LocalStorageService localStorage = LocalStorageService();
  DataState dataState = DataState.initial;

  Future<void> fetchStates() async {
    loading();
    try {
      final basestates = await _masterRepository.fetchStates();
      if (basestates.status == 1) {
        states = basestates.result;
        dataState = DataState.loaded;
      } else {
        errorMsg = basestates.message;
       dataState = DataState.error;
      }
    } catch (e) {
      debugPrint('Error in StateProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      loadingStop();
    }
  }

  Future<void> fetchDistricts(String stateId) async {
    setSelectedState(stateId);
    loading();

    try {
      final rawDistricts = await _masterRepository.fetchDistricts(stateId);
      baseStatus = rawDistricts.status;
      if (rawDistricts.status == 1) {
        districts = rawDistricts.result;
        dataState = DataState.loaded;
      } else {
        errorMsg = rawDistricts.message;
        dataState = DataState.error;
      }
        for (int i = 0; i < districts.length; i++) {
          if (localStorage.getString(AppConstants.prefDistrictId).toString() ==
              districts[i].jjmDistrictId) {
            localStorage.saveString(
                AppConstants.prefDistName, districts[i].districtName);
            setSelectedDistrict(districts[i].jjmDistrictId);
          }
        }

    } catch (e) {
      debugPrint('Error in fetching districts: master provider $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load districts.";
    } finally {
      loadingStop();
    }
  }

  Future<void> fetchBlocks(String stateId, String districtId) async {
    if (stateId.isEmpty || districtId.isEmpty) {
      errorMsg = "Please select both State and District.";
      notifyListeners();
      return;
    }
    loading();

    try {
      final rawBlocks =
          await _masterRepository.fetchBlocks(stateId, districtId);
      baseStatus = rawBlocks.status;

      if (rawBlocks.status == 1) {
        blocks = rawBlocks.result;
        dataState = DataState.loaded;
      } else {
        errorMsg = rawBlocks.message;
        dataState = DataState.error;
      }
    } catch (e) {
      debugPrint('Error in fetching blocks: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load blocks.";
    } finally {
      loadingStop();
    }
  }

  Future<void> fetchGramPanchayat(
      String stateId, String districtId, String blockId) async {
    if (stateId.isEmpty || districtId.isEmpty || blockId.isEmpty) {
      errorMsg = "Please select State, District, and Block.";
      notifyListeners();
      return;
    }
    loading();

    try {
      final rawGPs = await _masterRepository.fetchGramPanchayats(
          stateId, districtId, blockId);

      baseStatus = rawGPs.status;

      if (rawGPs.status == 1) {
        gramPanchayat = rawGPs.result;
        dataState = DataState.loaded;
        if (gramPanchayat != null && gramPanchayat.length == 1) {
          final singleGP = gramPanchayat!.first;
          setSelectedGrampanchayat(singleGP.jjmPanchayatId);
        }
      } else {
        errorMsg = rawGPs.message;
        dataState = DataState.error;
      }
    } catch (e) {
      debugPrint('Error in fetching grampanchayat: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load Gram Panchayats.";
    } finally {
      loadingStop();
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

    loading();
    try {
      final rawVillages = await _masterRepository.fetchVillages(
          stateId, districtId, blockId, gpID);

      baseStatus = rawVillages.status;

      if (rawVillages.status == 1) {
        village = rawVillages.result;

        if (village != null && village!.length == 1) {
          final singleVillage = village!.first;
          setSelectedVillage(singleVillage.jjmVillageId);

          await fetchHabitations(
            stateId,
            districtId,
            blockId,
            gpID,
            singleVillage.jjmVillageId,
          );
        } else {
          dataState = DataState.loaded;
        }
      } else {
        errorMsg = rawVillages.message;
        dataState = DataState.error;
      }
    } catch (e) {
      debugPrint('Error in fetching village: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load villages.";
    } finally {
      loadingStop();
    }
  }

  Future<void> fetchHabitations(String stateId, String districtId,
      String blockId, String gpId, String villageId) async {
    if ([stateId, districtId, blockId, gpId, villageId].any((e) => e.isEmpty)) {
      errorMsg = "Please select all fields to load habitations.";
      notifyListeners();
      return;
    }
    loading();

    try {
      final rawHabitations = await _masterRepository.fetchHabitations(
          stateId, districtId, blockId, gpId, villageId);

      baseStatus = rawHabitations.status;

      if (rawHabitations.status == 1) {
        habitationId = rawHabitations.result;

        if (habitationId != null && habitationId!.length == 1) {
          final singleHabitation = habitationId!.first;
          setSelectedHabitation(singleHabitation.habitationId);
        }
        dataState = DataState.loaded;
      } else {
        errorMsg = rawHabitations.message;
        dataState = DataState.error;
      }
    } catch (e) {
      debugPrint('Error in fetching habitation: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load habitations.";
    } finally {
      loadingStop();
    }
  }

  Future<void> fetchSchemes(String villageId, String habitationId,
      String districtid, String filter) async {
    loading();

    try {
      final mSchemes = await _masterRepository.fetchSchemes(
          villageId, habitationId, districtid, filter);
      baseStatus = mSchemes.status;

      if (baseStatus == 1) {
        schemes = mSchemes.result;
        dataState = DataState.loaded;
        if (schemes.length == 1) {
          selectedScheme = schemes.first.schemeId.toString();
        }
      } else {
        errorMsg = mSchemes.message;
        dataState = DataState.error;
      }
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
      loadingStop();
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
    loading();
    try {
      final rawWaterSource = await _masterRepository.fetchSourceInformation(
          villageId,
          habitationId,
          filter,
          cat,
          subcat,
          wtpId,
          stateId,
          schemeId);
      baseStatus = rawWaterSource.status;

      if (rawWaterSource.status == 1) {
        dataState = DataState.loaded;
        waterSource = rawWaterSource.result;
        if (waterSource.length == 1) {
          selectedWaterSource = waterSource.first.locationId.toString();
        }
      } else {
        errorMsg = rawWaterSource.message;
        if (waterSource.isEmpty) {
          dataState = DataState.loadedEmpty;
        }else {
        dataState = DataState.error;
      }
      }
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      loadingStop();
    }
  }

  Future<void> fetchWTPList(String stateId, String schemeId) async {
    loading();

    try {
      final fetchedList =
          await _masterRepository.fetchWTPlist(stateId, schemeId);

      if (fetchedList.status == 1) {
        dataState = DataState.loaded;
        wtpList = fetchedList.result;
        if (wtpList.length == 1) {
          selectedWtp = wtpList.first.wtpId;
        }
      } else {
        errorMsg = fetchedList.message;
        dataState = DataState.error;
      }
      baseStatus = fetchedList.status;
    } catch (e) {
      debugPrint('Error in fetching WTP list: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      loadingStop();
    }
  }

  Future<void> fetchWatersourcefilterList() async {
    loading();

    try {
      final rawWtsFilterList =
          await _masterRepository.fetchWaterSourceFilterList();
      baseStatus = rawWtsFilterList.status;
      if (rawWtsFilterList.status == 1) {
        dataState = DataState.loaded;
        wtsFilterList = rawWtsFilterList.result;
      } else {
        dataState = DataState.error;
        errorMsg = rawWtsFilterList.message;
      }
    } catch (e) {
      debugPrint('Error in StateProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      loadingStop();
    }
  }

  Future<void> fetchVillageDetails(double lon, double lat) async {
    loading();
    errorMsg = "";

    try {
      String formattedLon = lon.toStringAsFixed(8);
      String formattedLat = lat.toStringAsFixed(8);

      _villageDetails = await _masterRepository.fetchVillageLgd(
        double.parse(formattedLon),
        double.parse(formattedLat),
      );

      if (_villageDetails.isEmpty) {
        dataState = DataState.error;
        errorMsg = "No village details found.";
      } else {
        dataState = DataState.loaded;
      }
    } catch (e) {
      debugPrint('Error in fetchVillageDetails: $e');
      errorMsg = e.toString();
    } finally {
      loadingStop();
    }
  }

  Future<void> fetchLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Requesting location permission...');
      bool permissionGranted = await LocationUtils.requestLocationPermission();

      if (permissionGranted) {
        debugPrint('Permission granted. Fetching location...');
        final locationData = await LocationUtils.getCurrentLocation();

        if (locationData != null) {
          _currentLatitude = locationData['latitude'];
          _currentLongitude = locationData['longitude'];

          // 🔥 Set global current location
          CurrentLocation.setLocation(
            lat: _currentLatitude!,
            lng: _currentLongitude!,
          );

          debugPrint('Location Fetched: Lat: $_currentLatitude, Lng: $_currentLongitude');
        } else {
          debugPrint("Location fetch failed (locationData is null)");
        }
      } else {
        debugPrint("Permission denied. Cannot fetch location.");
      }
    } catch (e) {
      debugPrint("Error during fetchLocation(): $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> validateVillage(String villageId, String lgdCode) async {
    loading();
    errorMsg = "";

    try {
      _validateVillageResponse =
          await _masterRepository.validateVillage(villageId, lgdCode);
      dataState = DataState.loaded;
    } catch (e) {
      errorMsg = e.toString();
      dataState = DataState.error;
    } finally {
      loadingStop();
    }
  }

  void loading() {
    dataState = DataState.loading;
    _isLoading = true;
    notifyListeners();
  }

  void loadingStop() {
    _isLoading = false;
    notifyListeners();
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
    waterSource = [];
    selectedWaterSource = '';
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
    blocks.clear(); // C
    gramPanchayat.clear();
    village.clear();
    habitationId.clear();
    notifyListeners();
  }

/*  void clearData() {
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
  }*/

  void selectRadioOption(int value) {
    if (value == 2 || value == 1) {
      setSelectedSubSource(value);
      Future.delayed(Duration.zero, () {
        fetchSourceInformation(
            selectedVillage!,
            selectedHabitation ?? "0",
            selectedWtsfilter!,
            value.toString(),
            "0",
            "0",
            selectedStateId!,
            selectedScheme!);
      });
    } else if (value == 3) {
      setSelectedWaterSourceInformation("0");
      setSelectedHouseHold(value);
      setSelectedSubSource(1);
    } else if (value == 4) {
      setSelectedHouseHold(value);
      setSelectedSubSource(2);
      fetchSourceInformation(
          selectedVillage!,
          selectedHabitation!,
          selectedWtsfilter!,
          selectedSubSource.toString(),
          "0",
          "0",
          selectedStateId!,
          selectedScheme!);
    } else if (value == 5) {
      setSelectedSubSource(value);
      fetchSourceInformation(
          selectedVillage!,
          selectedHabitation!,
          selectedWtsfilter!,
          "0",
          "0",
          selectedWtp!,
          selectedStateId!,
          selectedScheme!);
    } else if (value == 6) {
      setSelectedSubSource(value);
    } else if (value == 7) {
      setSelectedHandpump(value);
      setSelectedSubSource(1);
      fetchSourceInformation(
          selectedVillage!,
          selectedHabitation!,
          selectedWtsfilter!,
          selectedSubSource.toString(),
          "0",
          "0",
          selectedStateId!,
          selectedScheme!);
    } else if (value == 8) {
      setSelectedHandpump(value);
      setSelectedSubSource(2);
      fetchSourceInformation(
          selectedVillage!,
          selectedHabitation!,
          selectedWtsfilter!,
          selectedSubSource.toString(),
          "0",
          "0",
          selectedStateId!,
          selectedScheme!);
    }
    notifyListeners();
  }

  void clearsampleinfo() {
    selectedWtsfilter = null;
    selectedScheme = null;
    notifyListeners();
  }
}
