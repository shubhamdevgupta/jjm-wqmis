import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/FTK/FtkDataResponse.dart';
import 'package:jjm_wqmis/providers/ftkProvider.dart';
import 'package:jjm_wqmis/utils/Aesen.dart';
import 'package:jjm_wqmis/utils/AppConstants.dart';
import 'package:jjm_wqmis/utils/AppStyles.dart';
import 'package:jjm_wqmis/utils/LoaderUtils.dart';
import 'package:jjm_wqmis/utils/Showerrormsg.dart';
import 'package:jjm_wqmis/utils/UserSessionManager.dart';
import 'package:jjm_wqmis/views/ftk/ftkDashboard.dart';
import 'package:jjm_wqmis/views/webView/testReport.dart';
import 'package:provider/provider.dart';

class ftkSampleListScreen extends StatefulWidget {
  const ftkSampleListScreen({super.key});

  @override
  State<ftkSampleListScreen> createState() => _ftkSampleListScreenState();
}

class _ftkSampleListScreenState extends State<ftkSampleListScreen> {
  final session = UserSessionManager();
  final encryption = AesEncryption();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      session.init();
      Ftkprovider ftkprovider =
          Provider.of<Ftkprovider>(context, listen: false);

      ftkprovider.fetchftkSampleList(session.regId, session.villageId, 0);
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
                                              "ID: ${sample.sampleId ?? 'N/A'}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                print('encypt-->>  ${encryption.encryptText(sample.sId.toString())}');
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => TestReport(
                                                        url: 'https://ejalshakti.gov.in/WQMIS/FTKUser/print_of_ftktest_result?s_id=${encryption.encryptText(sample.sId.toString())}'),
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
                                              sample.otherSourceLocation,
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
                                              "${sample.villageName ?? 'N/A'}, "
                                              "${sample.grampanchayat ?? 'N/A'}, "
                                              "${sample.blockName ?? 'N/A'}, "
                                              "${sample.districtName ?? 'N/A'}",
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
                                                    color: sample
                                                                .contaminatedStatus ==
                                                            "Report Approved"
                                                        ? Colors.green[100]
                                                        : sample.contaminatedStatus ==
                                                                "Under Process"
                                                            ? Colors.yellow[100]
                                                            : Colors.blue[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Text(
                                                    sample.contaminatedStatus ??
                                                        'N/A',
                                                    style: TextStyle(
                                                      color: sample
                                                                  .contaminatedStatus ==
                                                              "Report Approved"
                                                          ? Colors.green[800]
                                                          : sample.contaminatedStatus ==
                                                                  "Under Process"
                                                              ? Colors
                                                                  .orange[800]
                                                              : Colors
                                                                  .blue[800],
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
