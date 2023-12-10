import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

abstract class CorsService {
  static const _origin = 'origin';

  static const _defaultHeadersList = [
    'accept',
    'accept-encoding',
    'authorization',
    'content-type',
    'dnt',
    'origin',
    'user-agent',
  ];

  static const _defaultMethodsList = [
    'DELETE',
    'GET',
    'OPTIONS',
    'PATCH',
    'POST',
    'PUT'
  ];

  static final Map<String, String> _defaultHeaders = {
    HttpHeaders.accessControlExposeHeadersHeader: '',
    HttpHeaders.accessControlAllowCredentialsHeader: 'true',
    HttpHeaders.accessControlAllowHeadersHeader: _defaultHeadersList.join(','),
    HttpHeaders.accessControlAllowMethodsHeader: _defaultMethodsList.join(','),
    HttpHeaders.accessControlMaxAgeHeader: '86400',
  };

  static Map<String, Object> _createCorsHeaders(String? reqOrigin) => {
        ..._defaultHeaders.map((key, value) => MapEntry(key, [value])),
        HttpHeaders.accessControlAllowOriginHeader: [reqOrigin ?? '*'],
      };

  static FutureOr<Response> Function(Request) corsMiddleware(
      FutureOr<Response> Function(Request) innerHandler) {
    return (request) {
      final corsHeaders = _createCorsHeaders(request.headers[_origin]);

      if (request.method == 'OPTIONS') {
        print('OPTIONS request');
        return Response.ok(null, headers: corsHeaders);
      }

      return Future.sync(() => innerHandler(request)).then((response) {
        corsHeaders.addAll(response.headers);
        return response.change(headers: corsHeaders);
      }, onError: (Object error, StackTrace stackTrace) {
        if (error is HijackException) throw error;
        throw error;
      });
    };
  }
}
