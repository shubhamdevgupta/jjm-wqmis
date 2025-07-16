import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:jjm_wqmis/providers/dwsm_provider.dart';
import 'package:provider/provider.dart';
import 'package:jjm_wqmis/main.dart'; // to access navigatorKey

class ImageDialogUtil {
  static void showImageDialog({
    required BuildContext context,
    required String title,
    required String? base64String,
    required bool shouldFetchDemoList,
    int? stateId,
    int? districtId,
    int? regId,
    int? type,
    String year = "2025-2026",
    String round = "0",
  }) {
    Uint8List? imageBytes;

    try {
      if (base64String != null && base64String.isNotEmpty) {
        imageBytes = base64Decode(base64String);
        if (imageBytes.isEmpty) imageBytes = null;
      }
    } catch (_) {
      imageBytes = null;
    }

    final dialogContext = navigatorKey.currentContext ?? context;

    if (dialogContext == null) {
      debugPrint("No valid context found for dialog.");
      return;
    }

    showDialog(
      context: dialogContext,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageBytes == null
              ? _noImageWidget()
              : Image.memory(
            imageBytes,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => _noImageWidget(),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              if (shouldFetchDemoList &&
                  stateId != null &&
                  districtId != null &&
                  regId != null &&
                  type != null) {
                final safeContext = navigatorKey.currentContext;
                if (safeContext != null) {
                  await Provider.of<DwsmProvider>(safeContext, listen: false)
                      .fetchDemonstrationList(
                    stateId, districtId, year, round, type, regId,
                  );
                }
              }
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  static Widget _noImageWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/ic_no_image.png',
          height: 120,
          width: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        const Text(
          "No Image Found or Invalid Format",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
