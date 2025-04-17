import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/DWSM/SchoolinfoResponse.dart';
import 'package:jjm_wqmis/providers/ParameterProvider.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:provider/provider.dart';

import '../../models/LabInchargeResponse/AllLabResponse.dart';
import '../../providers/masterProvider.dart';
import '../../services/LocalStorageService.dart';
import '../../utils/CustomSearchableDropdown.dart';
import '../../utils/LoaderUtils.dart';

class Schoolpage extends StatefulWidget {
  @override
  _Schoolpage createState() => _Schoolpage();
}

class _Schoolpage extends State<Schoolpage> {
  late Masterprovider masterProvider;
  final LocalStorageService _localStorage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    masterProvider = Provider.of<Masterprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ParameterProvider>(context, listen: false).isLab=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<ParameterProvider>(context, listen: false),
      child: Consumer<ParameterProvider>(
        builder: (context, provider, child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomSearchableDropdown(
                            title: "",
                            value: provider.selectedSchoolResult,
                            items: provider.schoolResult
                                .map((school) =>
                            school.name ?? '') // Display text, not value
                                .toList(),
                            onChanged: (selectedSchoolResult) {
                              if (selectedSchoolResult == null)
                                return; // Handle null case

                              final selectedSchool = provider.schoolResult.firstWhere(
                                    (school) => school.name == selectedSchoolResult,
                                orElse: () => SchoolResult(name: "",demonstrated: 0,id: 0), // Default to a nullable object
                              );
                              provider.setSelectedLab(selectedSchool.name);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (provider.isLoading)
                    LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                ],
              ),



            ),
          );
        },
      ),
    );
  }


}
