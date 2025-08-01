import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/FTK/ftk_data_response.dart';
import 'package:jjm_wqmis/providers/ftk_provider.dart';
import 'package:jjm_wqmis/utils/encyp_decyp.dart';
import 'package:jjm_wqmis/utils/app_constants.dart';
import 'package:jjm_wqmis/utils/app_style.dart';
import 'package:jjm_wqmis/utils/loader_utils.dart';
import 'package:jjm_wqmis/utils/show_error_msg.dart';
import 'package:jjm_wqmis/utils/user_session_manager.dart';
import 'package:jjm_wqmis/utils/webView/testReport.dart';
import 'package:jjm_wqmis/views/ftk_data/ftk_dashboard.dart';

import 'package:provider/provider.dart';

class FtkSampleListScreen extends StatefulWidget {
  const FtkSampleListScreen({super.key});

  @override
  State<FtkSampleListScreen> createState() => _ftkSampleListScreenState();
}

class _ftkSampleListScreenState extends State<FtkSampleListScreen> {
  final session = UserSessionManager();
  final encryption = AesEncryption();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    await  session.init();
      Ftkprovider ftkprovider =
          Provider.of<Ftkprovider>(context, listen: false);

    await  ftkprovider.fetchftkSampleList(session.regId, session.villageId, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppConstants.navigateToFtkDashboard,
          (route) => false, // Clears all previous routes
        );
        return false; // Prevents default back action
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icons/header_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 5,
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ftkDashboard()),
                    (route) => false,
                  );
                }
              },
            ),
            title: Text('Ftk Sample List',style: AppStyles.appBarTitle,
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
          ),
          body: Consumer<Ftkprovider>(
            builder: (context, provider, child) {
              return provider.isLoading
                  ? LoaderUtils.conditionalLoader(isLoading: provider.isLoading)
                  : provider.ftkSample.isEmpty
                      ? AppTextWidgets.errorText(provider.errorMsg)
                      : ListView.builder(
                          itemCount: provider.ftkSample.length,
                          itemBuilder: (context, index) {
                            FtkSample sample = provider.ftkSample[
                                index]; // where result is List<Sample>

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ID Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: Text(
                                              "${index + 1}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          //SizedBox(width: 10),

                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "ID: ${sample.sampleId}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => TestReport(
                                                        url: 'https://ejalshakti.gov.in/wqmis//ftkuser/print_of_ftktest_result_API?s_id=${sample.sId}&RegId=${session.regId}'),
                                                  ),
                                                );
                                              },
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.brown,
                                                child: Icon(
                                                  Icons.download,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      const Divider(),

                                      // Lab Name
                                      Row(
                                        children: [
                                          const Icon(Icons.business,
                                              color: Colors.blue),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              sample.otherSourceLocation??'not found',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Location
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.blue),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              "${sample.villageName}, "
                                              "${sample.grampanchayat}, "
                                              "${sample.blockName}, "
                                              "${sample.districtName}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'OpenSans',
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      const Divider(),

                                      // Test Result
                                      Row(
                                        children: [
                                          const Icon(Icons.category,
                                              color: Colors.blue),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Test Result: ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: sample.contaminatedStatus == "Contaminated"
                                                        ? Colors.red[100] :  Colors.green[100], borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Text(
                                                    sample.contaminatedStatus,
                                                    style: TextStyle(
                                                      color: sample.contaminatedStatus == "Contaminated"
                                                          ? Colors.red[800] : Colors.green[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      fontFamily: 'OpenSans',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      const Divider(),

                                      // Date of Submission
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              color: Colors.blue),
                                          const SizedBox(width: 5),
                                          Text(
                                            "Date of Submission: ${sample.sampleCollectionTime ?? 'N/A'}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'OpenSans',
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
            },
          ),
        ),
      ),
    );
  }
}
