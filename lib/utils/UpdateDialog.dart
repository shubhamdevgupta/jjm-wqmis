import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/models/UpdateResponse.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogUtils {
  static void showUpdateDialog(BuildContext context, Updateresponse updateInfo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Available'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What\'s New:'),
              SizedBox(height: 8),
              Text(updateInfo.whatsNew),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('Update Now'),
              onPressed: () async {
                final url = updateInfo.apkUrl;
                final uri = Uri.parse(url);
                if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        );
      },
    );
  }
}

