import 'dart:convert';

import '../enums/resp_type.dart';

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
}
