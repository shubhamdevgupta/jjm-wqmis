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

import 'package:jjm_wqmis/models/LgdResponse.dart';
import 'package:jjm_wqmis/models/MasterApiResponse/BlockResponse.dart';
import 'package:jjm_wqmis/models/ValidateVillage.dart';
import 'package:jjm_wqmis/services/LocalStorageService.dart';
import 'package:jjm_wqmis/utils/CurrentLocation.dart';
import 'package:jjm_wqmis/utils/custom_screen/GlobalExceptionHandler.dart';
import 'package:jjm_wqmis/utils/LocationUtils.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> fetchStates() async {
    _isLoading = true;
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
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDistricts(String stateId) async {
    setSelectedState(stateId);
    _isLoading = true;
    notifyListeners();

    try {
      final rawDistricts = await _masterRepository.fetchDistricts(stateId);
      baseStatus = rawDistricts.status;
      if (rawDistricts.status == 1) {
        districts = rawDistricts.result;
      } else {
        errorMsg = rawDistricts.message;
      }


    } catch (e,stackTrace) {
      debugPrint('Error in fetching districts: master provider $e');
      debugPrint('Error in fetching districts: master provider $stackTrace');
      GlobalExceptionHandler.handleException(e as Exception);
      errorMsg = "Failed to load districts.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBlocks(String stateId, String districtId) async {
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
          await _masterRepository.fetchBlocks(stateId, districtId);
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
      String stateId, String districtId, String blockId) async {
    if (stateId.isEmpty || districtId.isEmpty || blockId.isEmpty) {
      errorMsg = "Please select State, District, and Block.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final rawGPs = await _masterRepository.fetchGramPanchayats(
          stateId, districtId, blockId);

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
      String stateId, String districtId, String blockId, String gpID) async {
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
          stateId, districtId, blockId, gpID);

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
            singleVillage.jjmVillageId,
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
      String blockId, String gpId, String villageId) async {
    if ([stateId, districtId, blockId, gpId, villageId].any((e) => e.isEmpty)) {
      errorMsg = "Please select all fields to load habitations.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final rawHabitations = await _masterRepository.fetchHabitations(
          stateId, districtId, blockId, gpId, villageId);

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
      String filter) async {
    _isLoading = true;
    notifyListeners();
    try {
      final mSchemes = await _masterRepository.fetchSchemes(stateId,
          districtid, villageId, habitationId, filter);
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
    String schemeId,
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
          schemeId);
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

  Future<void> fetchWTPList(String stateId, String schemeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final fetchedList =
          await _masterRepository.fetchWTPlist(stateId, schemeId);

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

  Future<void> fetchWatersourcefilterList() async {
    _isLoading = true;
    notifyListeners(); // Start loading
    try {
      final rawWtsFilterList = await _masterRepository.fetchWaterSourceFilterList();
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



  // ✅ Optional helper method
  void setLocation(double? lat, double? lng) {
    _latitude = lat;
    _longitude = lng;
    notifyListeners();
  }


  Future<void> checkAndPromptLocation(BuildContext context) async {
    _isLoading = true;

    final status = await Permission.location.request();

    if (status.isGranted) {
      Location location = Location();

      // Check if GPS is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _isLoading=false;
          // Show dialog if user still refuses
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
                    await openAppSettings();
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

      // ✅ Now GPS is ON and permission is granted
      LocationData locationData = await location.getLocation();

      setLocation(locationData.latitude, locationData.longitude);
      _isLoading=false;
      print("Lat: $_latitude, Lng: $_longitude");

    } else {
      _isLoading=false;
      // Permission denied
      await openAppSettings();
    }
  }

  Future<void> validateVillage(String villageId, String lgdCode) async {
    _isLoading = true;
    errorMsg = "";
    notifyListeners();
    try {
      _validateVillageResponse =
          await _masterRepository.validateVillage(villageId, lgdCode);
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
    districts.clear(); // Clear districts when state changes
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
    states.clear();
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
