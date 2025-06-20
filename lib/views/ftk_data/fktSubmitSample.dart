import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ftkProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/Showerrormsg.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:jjm_wqmis/utils/custom_screen/ftkParameterScreen.dart';
import 'package:jjm_wqmis/utils/toast_helper.dart';
import 'package:provider/provider.dart';

class FtkParameterListScreen extends StatefulWidget {
  const FtkParameterListScreen({super.key});

  @override
  State<FtkParameterListScreen> createState() => _FtkParameterListScreenState();
}

class _FtkParameterListScreenState extends State<FtkParameterListScreen> {
  late Masterprovider masterProvider;
  final session = UserSessionManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     await session.init();
      final ftkProvider = Provider.of<Ftkprovider>(context, listen: false);
      await ftkProvider.fetchParameterList(session.stateId, session.districtId);
      masterProvider = Provider.of<Masterprovider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/icons/header_bg.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(
                    context, AppConstants.navigateToftkSampleInfoScreen);
              }
            },
          ),
          // Removes the default back button
          centerTitle: true,
          title: Text(
            "Water Quality Parameters",
            style: AppStyles.appBarTitle,
          ),

          //elevation
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF096DA8), // Dark blue color
                  Color(0xFF3C8DBC), // Green color
                ],
                begin: Alignment.topCenter, // Start at the top center
                end: Alignment.bottomCenter, // End at the bottom center
              ),
            ),
          ),
          elevation: 5,
        ),
        body: Consumer<Ftkprovider>(
          builder: (context, ftkProvider, child) {
            return ftkProvider.isLoading
                ? LoaderUtils.conditionalLoader(
                    isLoading: ftkProvider.isLoading)
                : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: ftkProvider.ftkParameterList.length,
                              itemBuilder: (context, index) {
                                final param = ftkProvider.ftkParameterList[index];
                                return WaterQualityParameterCard(
                                  index: index,
                                  parameterName: param.parameterName,
                                  measurementUnit: param.measurementUnit,
                                  acceptableLimit: param.acceptableLimit,
                                  permissibleLimit: param.permissibleLimit,
                                  selectedValue: param.selectedValue,
                                  onChanged: (val) {
                                    ftkProvider.setSelectedParamForIndex(
                                        index, val!);
                                  },
                                );
                              },
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity, // or any appropriate width like 250, 300
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await validateAndSaveData(context,ftkProvider);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color: Colors.blueAccent, width: 1.5),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  child: const Text('Submit'),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                  ),
                );
          },
        ),
      ),
    );
  }

  Future<void> validateAndSaveData(BuildContext context, Ftkprovider ftkProvider) async {
    final parsedSource = int.tryParse(masterProvider.selectedWaterSource?.toString() ?? '') ?? 0;

    print('--->> parameter ID ${ftkProvider.getSelectedParameterIds()}');
    print('--- parameter value ${ftkProvider.getSelectedParameterValues()}');
    print('---- after parsing $parsedSource');
    print('---- default remark value: ${masterProvider.ftkRemarkController.text}');

    await masterProvider.fetchLocation();
    await ftkProvider.fetchDeviceId();

    if (ftkProvider.getSelectedParameterIds().isEmpty || ftkProvider.getSelectedParameterValues().isEmpty) {
      ToastHelper.showErrorSnackBar(context, 'Please select parameter');
      return;
    }
    await ftkProvider.saveFtkData(
      session.loginId,
      session.regId,
      session.roleId,
      masterProvider.selectedDatetimeSampleCollection,
      masterProvider.selectedDatetimeSampleTested,
      masterProvider.selectedSubSource,
      parsedSource,
      session.stateId,
      session.districtId,
      session.blockId,
      session.panchayatId,
      session.villageId,
      int.parse(masterProvider.selectedHabitation!),
      masterProvider.addressController.text,
      masterProvider.ftkRemarkController.text,
      int.parse(masterProvider.selectedWtsfilter!),
      int.parse(masterProvider.selectedScheme!),
      masterProvider.otherSourceLocation,
      masterProvider.selectedWaterSourceName ?? '',
      masterProvider.currentLatitude.toString(),
      masterProvider.currentLongitude.toString(),
      ftkProvider.deviceId,
      masterProvider.sampleTypeOther,
      ftkProvider.getSelectedParameterIds(),
      ftkProvider.getSelectedParameterValues(),
    );

    if (ftkProvider.sampleresponse?.status == 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.only(top: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          title: Column(
            children: [
              Image.asset('assets/icons/check.png', height: 60, width: 80),
              const SizedBox(height: 10),
              const Text(
                "Success!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          content: Text(
            ftkProvider.sampleresponse?.message ?? 'Ftk Submitted successfully!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  masterProvider.clearDataforFtk();
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppConstants.navigateToFtkDashboard,
                        (route) => false,
                  );
                },
                child: const Text("OK", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    } else {
      ToastHelper.showErrorSnackBar(context, ftkProvider.errorMsg);
    }
  }

}
