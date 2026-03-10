// Flutter layout for the 'Sample Information' form
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/custom_screen/custom_dropdown.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/ftk_data/widgets/esr_water_widget.dart';
import 'package:jjm_wqmis/views/ftk_data/widgets/handpump_water_widget.dart';
import 'package:jjm_wqmis/views/ftk_data/widgets/household_water_widget.dart';
import 'package:jjm_wqmis/views/ftk_data/widgets/scheme_dropdown_widget.dart';
import 'package:jjm_wqmis/views/ftk_data/widgets/source_scheme_widget.dart';
import 'package:provider/provider.dart';

class ftkSampleInformationScreen extends StatefulWidget {
  const ftkSampleInformationScreen({super.key});

  @override
  _ftkSampleinformationscreen createState() => _ftkSampleinformationscreen();
}

class _ftkSampleinformationscreen extends State<ftkSampleInformationScreen> {
  final session = UserSessionManager();

  String? sourceId; // 👈 Store the ID here
  String? sourceType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await session.init();
      final masterProvider =
          Provider.of<Masterprovider>(context, listen: false);
      masterProvider.setSelectedVillageOnly(session.villageId.toString());
      masterProvider.setSelectedStateOnly(session.stateId.toString());
      masterProvider.setSelectedHabitation('0');
      await masterProvider.fetchHabitations(
          session.stateId.toString(),
          session.districtId.toString(),
          session.blockId.toString(),
          session.panchayatId.toString(),
          session.villageId.toString(),
          session.regId);

      await masterProvider.fetchSchemes(
          session.stateId.toString(),
          session.districtId.toString(),
          session.villageId.toString(),
          masterProvider.selectedHabitation!,
          sourceId.toString(),
          session.regId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map) {
      sourceId = args['sourceId'];
      sourceType = args['sourceType'];

      debugPrint("sourceId: $sourceId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WillPopScope(
        onWillPop: () async {
          // Navigate back to Dashboard when pressing back button
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppConstants.navigateToFtkSampleScreen,
            (route) => false, // Clears all previous routes
          );
          return false; // Prevents default back action
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icons/header_bg.png'),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 5,
                centerTitle: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(8),
                    right: Radius.circular(8),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(
                          context, AppConstants.navigateToDashboardScreen);
                    }
                  },
                ),
                title: Text(
                  'Ftk Collection form',
                  style: AppStyles.appBarTitle,
                ),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF096DA8), // Dark blue color
                        Color(0xFF3C8DBC), // jjm blue color
                      ],
                      begin: Alignment.topCenter, // Start at the top center
                      end: Alignment.bottomCenter, // End at the bottom center
                    ),
                  ),
                ),
              ),
              body: Consumer<Masterprovider>(
                  builder: (context, masterProvider, child) {
                return masterProvider.isLoading
                    ? LoaderUtils.conditionalLoader(
                        isLoading: masterProvider.isLoading)
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //card for state district selection
                              buildSampleTaken(masterProvider),

                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      );
              })),
        ),
      ),
    );
  }

  Widget buildSchemeDropDown(Masterprovider masterProvider) {
    return masterProvider.baseStatus == 0 &&
            masterProvider.selectedScheme == null
        ? AppTextWidgets.errorText(masterProvider.errorMsg)
        : Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(left: 5, right: 5),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Scheme",
                    style: TextStyle(
                      fontSize: 16, fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // Dark text for better readability
                    ),
                  ),

                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 4), // Space between title and dropdown
                  CustomDropdown(
                    value: masterProvider.selectedScheme,
                    items: masterProvider.schemes.map((scheme) {
                      return DropdownMenuItem<String>(
                        value: scheme.schemeId.toString(),
                        child: Text(
                          scheme.schemeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      );
                    }).toList(),
                    title: "",
                    appBarTitle: "Select Scheme",
                    showSearchBar: true,
                    onChanged: (value) {
                      masterProvider.clearSelection();

                      masterProvider.setSelectedScheme(value);
                      if (sourceId == "5") {
                        masterProvider.fetchWTPList(
                            masterProvider.selectedStateId!,
                            masterProvider.selectedVillage!,
                            masterProvider.selectedHabitation!,
                            value!,
                            session.regId);
                      } else if (sourceId == "6") {
                        masterProvider.setSelectedSubSource(0);
                        masterProvider.setSelectedWTP("0");
                        masterProvider.fetchSourceInformation(
                            masterProvider.selectedVillage!,
                            masterProvider.selectedHabitation!,
                            sourceId.toString(),
                            "0",
                            masterProvider.selectedSubSource.toString(),
                            masterProvider.selectedWtp!,
                            masterProvider.selectedStateId!,
                            masterProvider.selectedScheme!,
                            session.regId);
                      }
                    },
                  )
                ],
              ),
            ),
          );
  }

  Widget buildSampleTaken(Masterprovider masterProvider) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          Center(
            child: Text(
              sourceType ?? 'N/A',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                fontFamily: 'OpenSans',
                letterSpacing: 0.3,
                color: Color(0xFF1A1A1A),
                height: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(thickness: 1, color: Colors.white60),

          /// SCHEME ONLY FOR NON HOUSEHOLD
          if (sourceId != "3")
            SchemeDropdownWidget(
              masterProvider: masterProvider,
              sourceId: sourceId,
              regId: session.regId,
            ),

          SourceOfSchemeWidget(
            masterProvider: masterProvider,
            sourceId: sourceId,
            session: session,
          ),

          EsrWaterWidget(
            masterProvider: masterProvider,
            sourceId: sourceId,
          ),

          HouseholdWaterWidget(
            masterProvider: masterProvider,
            sourceId: sourceId,
            session: session,
          ),

          HandpumpWaterWidget(
            masterProvider: masterProvider,
            sourceId: sourceId,
          ),
        ],
      ),
    );
  }
}
