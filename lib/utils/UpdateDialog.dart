import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/UpdateResponse.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogUtils {
  static void showUpdateDialog(BuildContext context, Updateresponse updateInfo) {
    const Color iconColor = Colors.blueAccent; // Or any color you prefer
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: iconColor.withOpacity(0.6), // Match your theme
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top icon in circle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: iconColor.withOpacity(0.6),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.system_update,
                  size: 36,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Update Available',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // What's new
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What\'s New:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Update details (bulleted)
              ...updateInfo.whatsNew.split('\n').map(
                    (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ", style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          line.trim(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0468B1),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // ← removes rounding
                      ),
                    ),
                    icon: const Icon(Icons.download, size: 18,color: Colors.white,),
                    label: const Text('Update Now',style: TextStyle(color: Colors.white),),
                    onPressed: () async {
                      final url = updateInfo.apkUrl;
                      final uri = Uri.parse(url);
                      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}

