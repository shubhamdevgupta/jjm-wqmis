import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showUpdateDialog(BuildContext context, Map<String, dynamic> updateInfo) {
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
              Text(updateInfo['whats_new']),
            ],
          ),
          actions: [

        /*    ElevatedButton(
              child: Text('Update Now'),
              onPressed: () async {
                final url = updateInfo['apk_url'];
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
            ),*/
          ],
        );
      },
    );
  }
}
