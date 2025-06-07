import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';



class CameraHelper {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  String? base64Image;

  /// Pick image from camera, compress, and convert to base64
  Future<void> pickFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        File compressed = await _compressImage(File(pickedFile.path));
        imageFile = compressed;
        base64Image = await _convertToBase64(compressed);

      }
    } catch (e) {
    }
  }

  /// Remove image and base64
  void removeImage() {
    imageFile = null;
    base64Image = null;
  }

  /// Compress image using flutter_image_compress
  Future<File> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 50,
    );

    final compressedPath = '${file.parent.path}/compressed_${file.uri.pathSegments.last}';
    final compressedFile = File(compressedPath)..writeAsBytesSync(result!);
    return compressedFile;
  }

  /// Convert image file to base64 string
  Future<String> _convertToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }
}

