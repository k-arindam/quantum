import 'dart:convert';

import 'package:http/http.dart' as http;

mixin NetworkService {
  Future<dynamic> post(
    Uri uri, {
    Map? payload,
    Map<String, String>? headers,
  }) async {
    try {
      final resp = await http.post(
        uri,
        body: jsonEncode(payload),
        headers: headers,
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return jsonDecode(resp.body);
      }

      throw Exception(resp.statusCode);
    } catch (e) {
      rethrow;
    }
  }
}
