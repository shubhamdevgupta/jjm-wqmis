import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/ftkProvider.dart';
import 'package:jjm_wqmis/providers/masterProvider.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:jjm_wqmis/views/ftk/ftkParameterScreen.dart';
import 'package:provider/provider.dart';

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
    final masterProvider = Provider.of<Masterprovider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Water Quality Parameters")),
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
                      measurementInfo:
                      '${param.acceptableLimit} ${param.measurementUnit} ${param.permissibleLimit}',
                      selectedValue: param.selectedValue, // ✅ pull from model
                      onChanged: (val) {
                        ftkProvider.setSelectedParamForIndex(index, val!); // ✅ set in model
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                    print('--->> parameter ID ${ftkProvider.getSelectedParameterIds()}  --- parameter value ${ftkProvider.getSelectedParameterValues()}');
                    masterProvider.fetchLocation();
                    ftkProvider.fetchDeviceId();
/*                    ftkProvider.saveFtkData(session.mobile, session.regId, session.roleId, masterProvider.selectedDatetimeSampleCollection,
                        masterProvider.selectedDatetimeSampleTested, sourceId, sourceLocation, session.stateId, session.districtId,
                        session.blockId, session.panchayatId, session.villageId,
                        masterProvider.selectedHabitation, masterProvider.addressController.text, '', masterProvider.selectedWtsfilter,
                        masterProvider.selectedScheme, masterProvider.otherSourceLocation, masterProvider.selectedWaterSource,
                        masterProvider.currentLatitude, masterProvider.currentLongitude, ftkProvider.deviceId,
                        masterProvider.sampleTypeOther, 0, ftkProvider.getSelectedParameterValues(), ftkProvider.getSelectedParameterIds());*/
                },
                child: const Text('Save Data'),
              )
            ],
          );
        },
      ),
    );
  }
}
