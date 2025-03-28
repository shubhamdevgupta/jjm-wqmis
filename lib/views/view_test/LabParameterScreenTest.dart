import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/views/view_test/AsPerLabTabViewTest.dart';

class LabParameterScreenTest extends StatefulWidget {
  @override
  _LabParameterScreenTest createState() => _LabParameterScreenTest();
}

class _LabParameterScreenTest extends State<LabParameterScreenTest>
    with SingleTickerProviderStateMixin {
  late TabController mTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mTabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> myTabs = <Tab>[
      Tab(
        icon: Icon(Icons.import_contacts_sharp),
        text: "As Per Laboratory",
      ),
      Tab(
        icon: Icon(Icons.arrow_back),
        text: 'As Per Parameter',
      )
    ];
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/header_bg.png'))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Select Lab/Parameter",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/savesample');
              }
            },
          ),
          backgroundColor: Colors.blueAccent,
          bottom: TabBar(controller: mTabController, tabs: myTabs),
        ),
        body: TabBarView(
          controller: mTabController,
          children: [AsPerLabTabView(), const Text("As Per Parameter")],

          /*children: myTabs.map((Tab tab) {
            final String? label = tab.text;
            return Center(
              child: Text(
                'This is the $label tab',
                style: const TextStyle(fontSize: 24),
              ),
            );
          }).toList(),*/
        ),
      ),
    );
  }
}
