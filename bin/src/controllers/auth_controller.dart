import 'dart:convert';

import 'package:shelf/shelf.dart';

class AuthController {
  static final AuthController _shared = AuthController._instance();

  factory AuthController() => _shared;
  AuthController._instance();

  Future<Response> loginHandler(Request request) async {
    final body = jsonDecode(await request.readAsString());

    final email = body["email"];
    final password = body["password"];

    if (email == null || password == null) {
      return Response.forbidden("Email and password are required");
    }

    return Response.ok("Login successful");
  }
}
