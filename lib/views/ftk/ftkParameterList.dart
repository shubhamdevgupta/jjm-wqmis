import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ftkProvider.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:jjm_wqmis/views/ftk/ftkParameterScreen.dart';
import 'package:provider/provider.dart';

import '../../utils/AppConstants.dart';
import '../../utils/AppStyles.dart';

class FtkParameterListScreen extends StatefulWidget {
  const FtkParameterListScreen({super.key});

  @override
  State<FtkParameterListScreen> createState() => _FtkParameterListScreenState();
}

class _FtkParameterListScreenState extends State<FtkParameterListScreen> {
  final session = UserSessionManager();
  
  @override
  void initState() {
    super.initState();
    final ftkProvider = Provider.of<Ftkprovider>(context, listen: false);
    ftkProvider.fetchParameterList(session.stateId, session.districtId);
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
            return Column(
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
                          ftkProvider.setSelectedParamForIndex(index, val!);
                        },
                      );
                    },
                  ),
                ),



                Center(
                  child: SizedBox(
                    width: 220, // or any appropriate width like 250, 300
                    child: ElevatedButton(
                      onPressed: () {
                        // Save action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.blueAccent, width: 1.5),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('Save Data'),
                    ),
                  ),
                )



              ],
            );
          },
        ),
      ),
    );
  }
}
