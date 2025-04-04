import 'package:flutter/material.dart';
import 'package:jjm_wqmis/views/view_test/AsPerLabView.dart';
import 'package:jjm_wqmis/views/view_test/AsPerParameterView.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:provider/provider.dart';

import '../../utils/Strings.dart';

class LabParameterScreenTest extends StatefulWidget {
  @override
  _LabParameterScreenTest createState() => _LabParameterScreenTest();
}

class _LabParameterScreenTest extends State<LabParameterScreenTest>
    with SingleTickerProviderStateMixin {
  late TabController mTabController;
  late ParameterProvider paramProvider;
  late Masterprovider masterProvider;

  @override
  void initState() {
    super.initState();
    mTabController = TabController(length: 2, vsync: this, initialIndex: 0);

    // Get providers
    paramProvider = Provider.of<ParameterProvider>(context, listen: false);
    masterProvider = Provider.of<Masterprovider>(context, listen: false);

    mTabController.addListener(() {
      if (mTabController.indexIsChanging) return; // Prevent duplicate calls

      if (mTabController.index == 0) {
        paramProvider.parameterList.clear();
        paramProvider.parameterType = 1;
        paramProvider.cart!.clear();
        paramProvider.isLabSelected=false;
        paramProvider.selectedLab=null;
        fetchAllLabs();
      } else if (mTabController.index == 1) {
        paramProvider.parameterList.clear();
        paramProvider.parameterType = 1;
        paramProvider.cart!.clear();
        paramProvider.selectedLab=null;
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
      "1",
    );
  }

  void fetchAllParameters() {
    paramProvider.fetchAllParameter(
      "0",
      masterProvider.selectedStateId ?? "0",
      "0",
      "1151455",
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
      const Tab(icon: Icon(Icons.add_business,color: Colors.white),
        child: Text("Select Laboratory", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,),),),
      const Tab(icon: Icon(Icons.compare_arrows,color: Colors.white,),
        child: Text('Test by Parameter', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,),),),
    ];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/header_bg.png')),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Select Lab/Parameter", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, Strings.navigateToSaveSample);
              }
            },
          ),
          bottom: TabBar(
            controller: mTabController,
            tabs: myTabs,
            labelColor: Colors.white, // White for selected tab text
            unselectedLabelColor: Colors.white70, // Slightly faded for unselected tabs
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            indicator: BoxDecoration(
              color: Color(0xFF5FAFE5), // Light blue indicator
              borderRadius: BorderRadius.circular(8),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              // Background color for the container
              borderRadius: BorderRadius.circular(8),
              // Rounded corners
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF096DA8), // Dark blue
                  Color(0xFF3C8DBC),  // jjm blue color
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,// End at the bottom center
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: TabBarView(
            controller: mTabController,
            children: [
              AsPerLabTabView(),
              Asperparameterview(),
            ],
          ),
        ),
      ),
    );
  }
}
