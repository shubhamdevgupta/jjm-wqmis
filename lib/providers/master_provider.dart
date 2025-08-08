// lib/providers/state_provider.dart

import 'package:flutter/material.dart';
import 'package:jjm_wqmis/database/database.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/grampanchayat_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/habitation_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/scheme_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/village_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/water_source_filter_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/water_source_response.dart';
import 'package:jjm_wqmis/models/MasterVillageData.dart';
import 'package:jjm_wqmis/models/Wtp/wtp_list_response.dart';
import 'package:jjm_wqmis/repository/master_repository.dart';

import 'package:jjm_wqmis/models/lgd_response.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/block_response.dart';
import 'package:jjm_wqmis/models/validate_village.dart';
import 'package:jjm_wqmis/services/local_storage_service.dart';
import 'package:jjm_wqmis/utils/current_location.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/utils/custom_screen/global_exception_handler.dart';
import 'package:jjm_wqmis/utils/location_utils.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class Masterprovider extends ChangeNotifier {
  final MasterRepository _masterRepository = MasterRepository();
  final session = UserSessionManager();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? selectedStateId;

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
  String? selectedWaterSourceName;

  List<Wtp> wtpList = [];
  String? selectedWtp;

  int istreated=0;

  double? _currentLatitude;
  double? _currentLongitude;

  double? get currentLatitude => _currentLatitude;

  double? get currentLongitude => _currentLongitude;
  double? _latitude;
  double? _longitude;

  // ✅ Getters
  double? get lat => _latitude;
  double? get lng => _longitude;
  List<Watersourcefilterresponse> wtsFilterList = [];
  String? selectedWtsfilter;

  List<Lgdresponse> _villageDetails =
      []; // Update to a List instead of a single object
  List<Lgdresponse> get villageDetails => _villageDetails;

  ValidateVillageResponse? _validateVillageResponse;

  ValidateVillageResponse? get validateVillageResponse =>
      _validateVillageResponse;

  MasterVillageData? _masterVillageData;

  MasterVillageData? get masterVillageData => _masterVillageData;
  int baseStatus = 0;
  int? _selectedSubSource;

  int? get selectedSubSource => _selectedSubSource;

  int? _selectedHouseHoldType;

  int? get selectedHousehold => _selectedHouseHoldType;

  int? _selectedHandpumpPrivate;

  int? get selectedHandpumpPrivate => _selectedHandpumpPrivate;

  String? _selectedDatetime = "";

  String? get selectedDatetime => _selectedDatetime;

  String? _selectedDatetimeSampleCollection = "";

  String? get selectedDatetimeSampleCollection => _selectedDatetimeSampleCollection;

  String? _selectedDatetimeSampleTested = "";

  String? get selectedDatetimeSampleTested => _selectedDatetimeSampleTested;

  final TextEditingController householdController = TextEditingController();
  final TextEditingController handpumpSourceController = TextEditingController();
  final TextEditingController handpumpLocationController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  TextEditingController ftkRemarkController = TextEditingController();
  String errorMsg = '';
  String otherSourceLocation = '';
  String sampleTypeOther = '';
  final LocalStorageService localStorage = LocalStorageService();

  Future<void> fetchBlocks(String stateId, String districtId, int regId) async {
    setSelectedState(stateId);
    setSelectedDistrict(districtId);

    if (stateId.isEmpty || districtId.isEmpty) {
      errorMsg = "Please select both State and District.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final rawBlocks =
          await _masterRepository.fetchBlocks(stateId, districtId, regId);
      baseStatus = rawBlocks.status;

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
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchGramPanchayat(
      String stateId, String districtId, String blockId ,int regId) async {
    if (stateId.isEmpty || districtId.isEmpty || blockId.isEmpty) {
      errorMsg = "Please select State, District, and Block.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final rawGPs = await _masterRepository.fetchGramPanchayats(
          stateId, districtId, blockId,regId);

      baseStatus = rawGPs.status;

      if (rawGPs.status == 1) {
        gramPanchayat = rawGPs.result;

        // ✅ Auto-select if only one Gram Panchayat is available
        if (gramPanchayat.length == 1) {
          final singleGP = gramPanchayat.first;
          setSelectedGrampanchayat(singleGP.jjmPanchayatId);
        }
      } else {
        errorMsg = rawGPs.message;
      }
    } catch (e) {
      debugPrint('Error in fetching grampanchayat: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load Gram Panchayats.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVillage(
      String stateId, String districtId, String blockId, String gpID,int regId) async {
    if (stateId.isEmpty ||
        districtId.isEmpty ||
        blockId.isEmpty ||
        gpID.isEmpty) {
      errorMsg = "Please select all required fields.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final rawVillages = await _masterRepository.fetchVillages(
          stateId, districtId, blockId, gpID,regId);

      baseStatus = rawVillages.status;

      if (rawVillages.status == 1) {
        village = rawVillages.result;

        if (village.length == 1) {
          final singleVillage = village.first;
          setSelectedVillage(singleVillage.jjmVillageId);

          /// ✅ Automatically trigger habitation fetch
          await fetchHabitations(
            stateId,
            districtId,
            blockId,
            gpID,
            singleVillage.jjmVillageId,regId
          );
        }
      } else {
        errorMsg = rawVillages.message;
      }
    } catch (e) {
      debugPrint('Error in fetching village: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load villages.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHabitations(String stateId, String districtId,
      String blockId, String gpId, String villageId,int regId) async {
    if ([stateId, districtId, blockId, gpId, villageId].any((e) => e.isEmpty)) {
      errorMsg = "Please select all fields to load habitations.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final rawHabitations = await _masterRepository.fetchHabitations(
          stateId, districtId, blockId, gpId, villageId,regId);

      baseStatus = rawHabitations.status;

      if (rawHabitations.status == 1) {
        habitationId = rawHabitations.result;

        // ✅ Auto-select habitation if only one is present
        if (habitationId.length == 1) {
          final singleHabitation = habitationId.first;
          setSelectedHabitation(singleHabitation.habitationId);
        }
      } else {
        errorMsg = rawHabitations.message;
      }
    } catch (e) {
      debugPrint('Error in fetching habitation: $e');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load habitations.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSchemes(String stateId, String districtid,String villageId, String habitationId,
      String filter,int regId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final mSchemes = await _masterRepository.fetchSchemes(stateId,
          districtid, villageId, habitationId, filter,regId);
      baseStatus = mSchemes.status;

      if (baseStatus == 1) {
        schemes = mSchemes.result;
        if (schemes.length == 1) {
          selectedScheme = schemes.first.schemeId.toString();
        }
      } else {
        errorMsg = mSchemes.message;
      }
      if (selectedWtsfilter == "5") {
        await fetchWTPList(selectedStateId!, selectedScheme!,regId);
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
          regId
        );
      }
    } catch (e) {
      debugPrint('Error in fetching scheme: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
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
    String schemeId, int regId
  ) async {
    _isLoading = true;
    try {
      final rawWaterSource = await _masterRepository.fetchSourceInformation(
          villageId,
          habitationId,
          filter,
          cat,
          subcat,
          wtpId,
          stateId,
          schemeId,regId);
      baseStatus = rawWaterSource.status;

      if (rawWaterSource.status == 1) {
        waterSource = rawWaterSource.result;
        if (waterSource.length == 1) {
          selectedWaterSource = waterSource.first.locationId.toString();
          selectedWaterSourceName= waterSource.first.locationName;
        }
      } else {
        errorMsg = rawWaterSource.message;
      }
    } catch (e) {
      debugPrint('Error in fetching source information: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWTPList(String stateId, String schemeId,int regId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final fetchedList =
          await _masterRepository.fetchWTPlist(stateId, schemeId,regId);

      if (fetchedList.status == 1) {
        wtpList = fetchedList.result;
        if (wtpList.length == 1) {
          selectedWtp = wtpList.first.wtpId;
        }
      } else {
        errorMsg = fetchedList.message;
      }
      baseStatus = fetchedList.status;
    } catch (e) {
      debugPrint('Error in fetching WTP list: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWatersourcefilterList(int regId) async {
    _isLoading = true;
    notifyListeners(); // Start loading
    try {
      final rawWtsFilterList = await _masterRepository.fetchWaterSourceFilterList(regId);
      baseStatus = rawWtsFilterList.status;
      if (rawWtsFilterList.status == 1) {
        wtsFilterList = rawWtsFilterList.result;
      } else {
        errorMsg = rawWtsFilterList.message;
      }
    } catch (e) {
      debugPrint('Error in StateProvider: $e');
      GlobalExceptionHandler.handleException(e as Exception);
    } finally {
      _isLoading = false;
      notifyListeners(); // Finish loading
    }
  }

  Future<void> fetchVillageDetails(double lon, double lat) async {
    _isLoading = true;
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
      _isLoading = false;
      notifyListeners();
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

  Future<void> masterVillagesData(String stateId, String districtId, String villageId) async {
    _isLoading = true;
    errorMsg = "";
    notifyListeners();

    try {
      // 1. Fetch from API
      _masterVillageData = await _masterRepository.masterVillageData(stateId, districtId, villageId);

      // 2. Open Floor DB
      final db = await $FloorAppDatabase
          .databaseBuilder('my_app_database.db')
          .build();

      // 3. Optional: Clear old data from all tables (initialize)
      await db.habitationDao.clearTable();
      await db.waterSourceFilterDao.clearTable();
      await db.schemeDao.clearTable();
      await db.sourcesDao.clearTable();
      await db.labDao.clearTable();
      await db.parameterDao.clearTable();
      await db.labInchargeDao.clearTable();

      // 4. Insert new data from API into tables
      await db.habitationDao.insertAll(
          _masterVillageData!.habitations.map((e) => e.toEntity()).toList()
      );

      await db.waterSourceFilterDao.insertAll(
          _masterVillageData!.waterSourceFilters.map((e) => e.toEntity()).toList()
      );

      await db.schemeDao.insertAll(
          _masterVillageData!.schemes.map((e) => e.toEntity()).toList()
      );

      await db.sourcesDao.insertAll(
          _masterVillageData!.sources.map((e) => e.toEntity()).toList()
      );

      await db.labDao.insertAll(
          _masterVillageData!.labs.map((e) => e.toEntity()).toList()
      );

      await db.parameterDao.insertAll(
          _masterVillageData!.parameters.map((e) => e.toEntity()).toList()
      );

      await db.labInchargeDao.insertAll(
          _masterVillageData!.labIncharges.map((e) => e.toEntity()).toList()
      );

    } catch (e) {
      errorMsg = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  // ✅ Optional helper method
  void setLocation(double? lat, double? lng) {
    _latitude = lat;
    _longitude = lng;
    notifyListeners();
  }


  Future<void> checkAndPromptLocation(BuildContext context) async {
    _isLoading = true;
    notifyListeners(); // if using Provider

    final location = Location();

    try {
      // 1. Check permission
      final status = await Permission.location.status;
      if (!status.isGranted) {
        final result = await Permission.location.request();
        if (!result.isGranted) {
          _isLoading = false;
          await openAppSettings(); // Open app settings if denied permanently
          return;
        }
      }

      // 2. Check if GPS is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService(); // prompts the user
        if (!serviceEnabled) {
          _isLoading = false;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Enable Location"),
              content: const Text("GPS is required to fetch location."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    await openAppSettings(); // redirect to location settings manually
                    Navigator.of(context).pop();
                  },
                  child: const Text("Open Settings"),
                ),
              ],
            ),
          );
          return;
        }
      }

      // 3. Get location
      final locationData = await location.getLocation();
      setLocation(locationData.latitude, locationData.longitude);
    } catch (e) {
      debugPrint("Error in checkAndPromptLocation: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // if using Provider
    }
  }

  Future<void> validateVillage(String villageId, String lgdCode,int regId) async {
    _isLoading = true;
    errorMsg = "";
    notifyListeners();
    try {
      _validateVillageResponse =
          await _masterRepository.validateVillage(villageId, lgdCode,regId);
    } catch (e) {
      errorMsg = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedDateTime(String? value) {
    _selectedDatetime = value;
    _selectedDatetimeSampleCollection = value;
    _selectedDatetimeSampleTested = value;
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


  void clearSelectedSubSource() {
    _selectedSubSource = null;
    notifyListeners(); // Notify listeners to rebuild the widget
  }

  void setSelectedWaterSourcefilterOnly(String? value) {
    selectedWtsfilter = value;
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
  void setSelectedWaterSourceInformationName(String? value) {
    selectedWaterSourceName = value;
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

  void setSelectedVillageOnly(String? village) {
    selectedVillage = village;
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
    blocks.clear(); // C
    gramPanchayat.clear();
    village.clear();
    habitationId.clear();
    notifyListeners();
  }
  void setSelectedStateOnly(String? stateId) {
    selectedStateId = stateId;
    notifyListeners();
  }



  void clearData() {
    selectedStateId = null;

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

    istreated = 0;

    _currentLatitude = null;
    _currentLongitude = null;

    wtsFilterList.clear();
    selectedWtsfilter = null;

    _villageDetails.clear();

    _validateVillageResponse = null;

    baseStatus = 0;
    _selectedSubSource = null;
    _selectedHouseHoldType = null;
    _selectedHandpumpPrivate = null;
    _selectedDatetime = '';

    errorMsg = '';
    otherSourceLocation = '';
    sampleTypeOther = '';
    ftkRemarkController.clear();
    addressController.clear();
    _isLoading = false;

    notifyListeners();
  }
  void clearDataforFtk() {
    habitationId.clear();
    selectedHabitation = null;

    schemes.clear();
    selectedScheme = null;

    waterSource.clear();
    selectedWaterSource = null;

    wtpList.clear();
    selectedWtp = null;

    istreated = 0;

    _currentLatitude = null;
    _currentLongitude = null;

    wtsFilterList.clear();
    selectedWtsfilter = null;

    _villageDetails.clear();

    _validateVillageResponse = null;

    baseStatus = 0;
    _selectedSubSource = null;
    _selectedHouseHoldType = null;
    _selectedHandpumpPrivate = null;
    _selectedDatetime = '';

    errorMsg = '';
    otherSourceLocation = '';
    sampleTypeOther = '';
    ftkRemarkController.clear();
    addressController.clear();
    householdController.clear();
    _isLoading = false;

    notifyListeners();
  }

  void clearSelectedWaterSource() {
    selectedWaterSource = null;
    selectedWaterSourceName = null; // if you're using name too
    notifyListeners();
  }

  void cleartxt() {
    handpumpSourceController.clear();
    householdController.clear();
    handpumpLocationController.clear();
    notifyListeners(); // Important if UI is bound to the controller values
  }

  void selectRadioOption(int value) {
    if (value == 2 || value == 1) {
      clearAddresRemarks();
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
            selectedScheme!,session.regId);
      });
    } else if (value == 3) {
      setSelectedWaterSourceInformation("0");
      setSelectedHouseHold(value);
      setSelectedSubSource(1);
      clearAddresRemarks();
    } else if (value == 4) {
      setSelectedHouseHold(value);
      setSelectedSubSource(2);
      clearAddresRemarks();
      householdController.clear();
      fetchSourceInformation(
          selectedVillage!,
          selectedHabitation!,
          selectedWtsfilter!,
          selectedSubSource.toString(),
          "0",
          "0",
          selectedStateId!,
          selectedScheme!,session.regId);
    } else if (value == 5) {
      setSelectedSubSource(value);
      clearAddresRemarks();
      fetchSourceInformation(
          selectedVillage!,
          selectedHabitation!,
          selectedWtsfilter!,
          "0",
          "0",
          selectedWtp!,
          selectedStateId!,
          selectedScheme!,session.regId);
    } else if (value == 6) {
      setSelectedSubSource(value);
    } else if (value == 7) {
      clearAddresRemarks();
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
          selectedScheme!,session.regId);
    } else if (value == 8) {
      clearAddresRemarks();
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
          selectedScheme!,session.regId);
    }
    notifyListeners();
  }

  void clearsampleinfo() {
    selectedWtsfilter = null;
    selectedScheme = null;
    notifyListeners();
  }

  void clearSelection(){
    clearSelectedSubSource();
    setSelectedHouseHold(null);
    setSelectedHandpump(null);
    clearAddresRemarks();
  }
  void clearAddresRemarks(){
    addressController.clear();
    ftkRemarkController.clear();
  }
}
