import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class AesEncryption {
  // Specific fixed key for encryption and decryption
  static const String key = "8080808080808080"; // 16 characters long key

  // Encrypt the plain text using AES
  String encryptText(String plainText) {
    final keyBytes = utf8.encode(key);
    final iv = keyBytes.sublist(0, 16);
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(Uint8List.fromList(keyBytes)), mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: encrypt.IV(Uint8List.fromList(iv)));
    return encrypted.base64;
  }

  // Decrypt the cipher text using AES
  String decryptText(String cipherText) {
    final keyBytes = utf8.encode(key);
    final iv = keyBytes.sublist(0, 16);
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(Uint8List.fromList(keyBytes)), mode: encrypt.AESMode.cbc));

    final decrypted = encrypter.decrypt64(cipherText, iv: encrypt.IV(Uint8List.fromList(iv)));
    return decrypted;
  }
}