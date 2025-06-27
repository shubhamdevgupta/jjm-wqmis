import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool isAtBottom = false;
  bool showScrollIcon = true;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     await session.init();
      final ftkProvider = Provider.of<Ftkprovider>(context, listen: false);
      await ftkProvider.fetchParameterList(session.stateId, session.districtId);
      masterProvider = Provider.of<Masterprovider>(context, listen: false);
    });


    _scrollController.addListener(() {
      final position = _scrollController.position;
      final max = position.maxScrollExtent;

      // Detect if at bottom or top
      if (position.pixels >= max && !isAtBottom) {
        setState(() => isAtBottom = true);
      } else if (position.pixels <= 0 && isAtBottom) {
        setState(() => isAtBottom = false);
      }
      // Optional: hide icon while scrolling
     /* if (position.userScrollDirection != ScrollDirection.idle && showScrollIcon) {
        setState(() => showScrollIcon = false);
      }*/

      // Show again after user stops scrolling
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => showScrollIcon = true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/header_bg.png'),
          fit: BoxFit.cover,
        ),
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
          centerTitle: true,
          title: Text(
            "Water Quality Parameters",
            style: AppStyles.appBarTitle,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF096DA8),
                  Color(0xFF3C8DBC),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          elevation: 5,
        ),
        body: SafeArea( // 👈 SafeArea added here
          child: Consumer<Ftkprovider>(
            builder: (context, ftkProvider, child) {
              return ftkProvider.isLoading
                  ? LoaderUtils.conditionalLoader(isLoading: ftkProvider.isLoading)
                  : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController, // 👈 attach the controller
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
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom + 4,
                      top: 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showScrollIcon)
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end, // 👈 Pushes icon to right
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: showScrollIcon ? 1.0 : 0.0,
                                  child: Icon(
                                    isAtBottom
                                        ? Icons.keyboard_double_arrow_up
                                        : Icons.keyboard_double_arrow_down,
                                    color: Colors.grey.shade400,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),


                        //  const SizedBox(height: 4), // spacing between icon and button
                      Center(
                          child: SizedBox(
                                width: double.infinity, // or any appropriate width like 250, 300
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await validateAndSaveData(context, ftkProvider);
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
                        ),
                      ],
                    ),
                  ),

                    ],
                  );
          },
        ),
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

    if (masterProvider.lat == null || masterProvider.lng == null) {
      await masterProvider.checkAndPromptLocation(context);

      if (masterProvider.lat == null || masterProvider.lng == null) {
        // User cancelled or GPS still off
        ToastHelper.showSnackBar(context, "Location is required to proceed.");
        return;
      }
    }



    await ftkProvider.fetchDeviceId();

    if (ftkProvider.getSelectedParameterIds().isEmpty || ftkProvider.getSelectedParameterValues().isEmpty) {
      ToastHelper.showErrorSnackBar(context, 'Please select at least 1 parameter');
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
