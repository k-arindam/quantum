import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

import '../enums/resp_type.dart';
import '../models/quantum_user.dart';
import '../services/utility_service.dart';
import 'database_controller.dart';

class AuthController {
  static final AuthController _shared = AuthController._instance();

  factory AuthController() => _shared;
  AuthController._instance();

  final _dbController = DatabaseController();
  final _uuid = Uuid();

  Response _createUserSession(QuantumUser user, {bool isLogin = true}) {
    final token = Utils.generateToken(user.email + user.id);
    // await _dbController.addToken(token: token, email: user.email);

    return Response.ok(Utils.generateResp(
      type: RespType.success,
      message: "${isLogin ? "Login" : "SignUp"} successful",
      data: {
        "token": token,
        "user": user.toJson(includePassword: false),
      },
    ));
  }

  Future<Response> loginHandler(Request request) async {
    final reqString = await request.readAsString();

    final misingParamsErr = Utils.generateResp(
      type: RespType.error,
      message: "Email and password are required",
    );

    if (reqString.isEmpty) {
      return Response.badRequest(body: misingParamsErr);
    }

    final body = jsonDecode(reqString);

    final email = body["email"];
    final password = body["password"];

    if (email == null || password == null) {
      return Response.forbidden(misingParamsErr);
    }

    try {
      QuantumUser user = await _dbController.getUser(email);

      if (!Utils.verifyPassword(password, user)) {
        return Response.unauthorized(Utils.generateResp(
          type: RespType.error,
          message: "Invalid password",
        ));
      }

      return _createUserSession(user);
    } catch (e) {
      return Response.forbidden(Utils.generateResp(
        type: RespType.error,
        message: e.toString(),
      ));
    }
  }

  Future<Response> signupHandler(Request request) async {
    final reqString = await request.readAsString();

    final misingParamsErr = Utils.generateResp(
      type: RespType.error,
      message: "Name, email and password are required",
    );

    if (reqString.isEmpty) {
      return Response.badRequest(body: misingParamsErr);
    }

    final body = jsonDecode(reqString);

    final name = body["name"];
    final email = body["email"];
    final password = body["password"];

    if (name == null || email == null || password == null) {
      return Response.forbidden(misingParamsErr);
    }

    if (await _dbController.isRegistered(email)) {
      return Response.forbidden(Utils.generateResp(
        type: RespType.error,
        message: "Email already registered !!!",
      ));
    }

    final user = QuantumUser(
      id: _uuid.v4(),
      name: name,
      email: email,
      password: Utils.encryptPassword(password),
    );

    if (await _dbController.addUser(user)) {
      return _createUserSession(user, isLogin: false);
    } else {
      return Response.forbidden(Utils.generateResp(
        type: RespType.error,
        message: "Unable to create user at this moment !!!",
      ));
    }
  }
}
