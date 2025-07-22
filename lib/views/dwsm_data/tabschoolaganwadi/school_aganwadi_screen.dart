import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/master_provider.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/anganwadi_screen.dart';
import 'package:jjm_wqmis/views/dwsm_data/tabschoolaganwadi/school_screen.dart';
import 'package:provider/provider.dart';

import 'package:jjm_wqmis/providers/dwsm_provider.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';


class Tabschoolaganwadi extends StatefulWidget {
  const Tabschoolaganwadi({super.key});

  @override
  _TabSchoolAganwadi createState() => _TabSchoolAganwadi();
}

class _TabSchoolAganwadi extends State<Tabschoolaganwadi>
    with SingleTickerProviderStateMixin {
  late TabController mTabController;
  late DwsmProvider dwsmDashboardProvider;
  late Masterprovider masterProvider;
  final session = UserSessionManager();

  @override
  void initState() {
    super.initState();
    mTabController = TabController(length: 2, vsync: this, initialIndex: 0);
    dwsmDashboardProvider = Provider.of<DwsmProvider>(context, listen: false);
    masterProvider = Provider.of<Masterprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DwsmProvider>(context, listen: false).clearData();
    });
    mTabController.addListener(() {
      if (mTabController.indexIsChanging) return;

      if (mTabController.index == 0) {
        fetchSchoolAwc(0);
        dwsmDashboardProvider.clearSelectedAnganwadi();
      } else if (mTabController.index == 1) {
        dwsmDashboardProvider.clearSelectedAnganwadi();
        fetchSchoolAwc(1);
        dwsmDashboardProvider.clearSelectedSchool();
      }
    });
    fetchSchoolAwc(0); //zero for schoool and 1 for anganwadi
  }

  void fetchSchoolAwc(int type) {
    dwsmDashboardProvider.fetchSchoolAwcInfo(
      int.parse(masterProvider.selectedStateId!),
      int.parse(masterProvider.selectedDistrictId!),
      int.parse(masterProvider.selectedBlockId!),
      int.parse(masterProvider.selectedGramPanchayat!),
      int.parse(masterProvider.selectedVillage!),
      type,session.regId
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
        icon: Icon(Icons.school_sharp, color: Colors.white),
        child: Text(
          "School",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const Tab(
        icon: Icon(
          Icons.house_sharp,
          color: Colors.white,
        ),
        child: Text(
          'Anganwadi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/icons/wqmis_bg_neeraj.jpeg')),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Select School/ Anganwadi",
              style: TextStyle(fontFamily: 'OpenSans', color: Colors.white)),
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
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight - 45,
              child: TabBarView(
                controller: mTabController,
                children: const [
                  SchoolScreen(),
                  AnganwadiScreen(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

enum DataState { initial, loading, error, loaded }
