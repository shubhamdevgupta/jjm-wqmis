import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:jjm_wqmis/utils/secretkey_service.dart';

class AesEncryption {
  static late String _key;

  static Future<void> initKey() async {
    _key = await SecretKeyService.getSecretKey();
  }

  encrypt.Encrypter _getEncrypter() {
    final keyBytes = utf8.encode(_key);
    return encrypt.Encrypter(
      encrypt.AES(
        encrypt.Key(Uint8List.fromList(keyBytes)),
        mode: encrypt.AESMode.cbc,
        padding: 'PKCS7',
      ),
    );
  }

  encrypt.IV _getIV() {
    final iv = utf8.encode(_key).sublist(0, 16);
    return encrypt.IV(iv);
  }

  String encryptText(String plainText) {
    final encrypter = _getEncrypter();
    final iv = _getIV();
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  String decryptText(String cipherText) {
    final encrypter = _getEncrypter();
    final iv = _getIV();
    return encrypter.decrypt64(cipherText, iv: iv);
  }
}