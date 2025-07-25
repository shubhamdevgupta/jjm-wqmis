import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/parameter_provider.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/dept_data/lab/lab_tab_screen.dart';
import 'package:jjm_wqmis/views/dept_data/lab/parameter_tab_screen.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';


class Labparameterscreen extends StatefulWidget {
  const Labparameterscreen({super.key});

  @override
  _LabParameterScreen createState() => _LabParameterScreen();
}

class _LabParameterScreen extends State<Labparameterscreen>
    with SingleTickerProviderStateMixin {
  late TabController mTabController;
  late ParameterProvider paramProvider;
  late Masterprovider masterProvider;
  final session = UserSessionManager();
  @override
  void initState() {
    super.initState();
    mTabController = TabController(length: 2, vsync: this, initialIndex: 0);
    // Get providers
    paramProvider = Provider.of<ParameterProvider>(context, listen: false);
    masterProvider = Provider.of<Masterprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async{
     await session.init();

      Provider.of<ParameterProvider>(context, listen: false).clearData();
    });
    mTabController.addListener(() {
      if (mTabController.indexIsChanging) return; // Prevent duplicate calls

      if (mTabController.index == 0) {
        paramProvider.parameterList.clear();
        paramProvider.parameterType = 1;
        paramProvider.cart!.clear();
        paramProvider.isLabSelected = false;
        paramProvider.selectedLab = null;
        fetchAllLabs();
      } else if (mTabController.index == 1) {
        paramProvider.parameterList.clear();
        paramProvider.parameterType = 1;
        paramProvider.cart!.clear();
        paramProvider.selectedLab = null;
        fetchAllParameters();
      }
    });

    fetchAllLabs();
  }

  void fetchAllLabs() {
    paramProvider.fetchAllLabs(
      masterProvider.selectedStateId!,
      masterProvider.selectedDistrictId!,
      masterProvider.selectedBlockId!,
      masterProvider.selectedGramPanchayat!,
      masterProvider.selectedVillage!,
      "1",session.regId
    );
  }

  void fetchAllParameters() {
    paramProvider.fetchAllParameter(
      "0",
      masterProvider.selectedStateId ?? "0",
      "0",
      session.regId.toString(),
      "1",
    );
  }

  @override
  void dispose() {
    mTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> myTabs = <Tab>[
      const Tab(
        icon: Icon(Icons.add_business, color: Colors.white),
        child: Text(
          "Select Laboratory",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16, fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const Tab(
        icon: Icon(
          Icons.compare_arrows,
          color: Colors.white,
        ),
        child: Text(
          'Test by Parameter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16, fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Select Lab/Parameter",
            style: AppStyles.appBarTitle),
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
                  context, AppConstants.navigateToSubmitSampleScreen);
            }
          },
        ),
        bottom: TabBar(
          controller: mTabController,
          tabs: myTabs,
          labelColor: Colors.white,
          // White for selected tab text
          unselectedLabelColor: Colors.white70,
          // Slightly faded for unselected tabs
          labelStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'OpenSans',),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontFamily: 'OpenSans'),
          indicator: BoxDecoration(
            color: const Color(0xFF5FAFE5), // Light blue indicator
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            gradient: LinearGradient(
              colors: [
                Color(0xFF096DA8), // Dark blue
                Color(0xFF3C8DBC), // jjm blue color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter, // End at the bottom center
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/icons/header_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          TabBarView(
            controller: mTabController,
            children: const [
              AsPerLabTabView(),
              Asperparameterview(),
            ],
          ),
        ],
      ),


    );
  }
}