import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class AesEncryption {
  static const String key = "8080808080808080"; // 16-char key

  String encryptText(String plainText) {
    final keyBytes = utf8.encode(key);
    final iv = keyBytes.sublist(0, 16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        encrypt.Key(Uint8List.fromList(keyBytes)),
        mode: encrypt.AESMode.cbc,
        padding: 'PKCS7',
      ),
    );

    final encrypted = encrypter.encrypt(plainText, iv: encrypt.IV(iv));
    return encrypted.base64;
  }

  String decryptText(String cipherText) {
    final keyBytes = utf8.encode(key);
    final iv = keyBytes.sublist(0, 16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        encrypt.Key(Uint8List.fromList(keyBytes)),
        mode: encrypt.AESMode.cbc,
        padding: 'PKCS7',
      ),
    );

    return encrypter.decrypt64(cipherText, iv: encrypt.IV(iv));
  }
}