import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../enums/resp_type.dart';
import '../global/constants.dart';
import '../models/quantum_user.dart';

abstract class Utils {
  static String generateResp({
    required RespType type,
    required String message,
    Map? data,
  }) {
    final Map<String, dynamic> resp = {
      'status': type.name,
      'message': message,
    };

    if (data != null) {
      resp['data'] = data;
    }

    return jsonEncode(resp);
  }

  static String generateToken(String data) {
    final now = DateTime.now();

    final bytes = utf8.encode(Constants.kSalt + data + now.toString());
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  static String encryptPassword(String password) {
    final key = utf8.encode(Constants.kSalt);
    final bytes = utf8.encode(password);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    final encryptedPassword = digest.toString();
    print("Encrypted password: $encryptedPassword");

    return encryptedPassword;
  }

  static bool verifyPassword(String password, QuantumUser user) =>
      encryptPassword(password) == user.password;
}
