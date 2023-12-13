import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../enums/resp_type.dart';
import '../models/quantum_user.dart';
import '../services/utility_service.dart';
import 'database_controller.dart';

class AuthController {
  static final AuthController _shared = AuthController._instance();

  factory AuthController() => _shared;
  AuthController._instance();

  final _dbController = DatabaseController();

  Future<Response> loginHandler(Request request) async {
    final body = jsonDecode(await request.readAsString());

    final email = body["email"];
    final password = body["password"];

    if (email == null || password == null) {
      return Response.forbidden(Utils.generateResp(
          type: RespType.error, message: "Email and password are required"));
    }

    try {
      QuantumUser user = await _dbController.getUser(email);

      if (!Utils.verifyPassword(password, user)) {
        return Response.unauthorized(Utils.generateResp(
          type: RespType.error,
          message: "Invalid password",
        ));
      }

      final token = Utils.generateToken(user.email + user.id);
      // await _dbController.addToken(token: token, email: user.email);

      return Response.ok(Utils.generateResp(
        type: RespType.success,
        message: "Login successful",
        data: {
          "token": token,
          "user": user.toJson(includePassword: false),
        },
      ));
    } catch (e) {
      return Response.forbidden(Utils.generateResp(
        type: RespType.error,
        message: e.toString(),
      ));
    }
  }
}
