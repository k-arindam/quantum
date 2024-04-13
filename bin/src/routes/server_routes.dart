import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/multipart.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import '../controllers/auth_controller.dart';
import '../controllers/llm_controller.dart';
import '../global/constants.dart';
import '../interfaces/quantum_llm.dart';

class ServerRoutes {
  static final ServerRoutes _shared = ServerRoutes._instance();

  factory ServerRoutes() => _shared;
  ServerRoutes._instance();

  final _router = Router();
  final _authController = AuthController();

  final QuantumLLM llm = LLMController();

  final _uploadsHandler = createStaticHandler(
    "uploads",
    listDirectories: true,
    useHeaderBytesForContentType: true,
  );

  final _publicHandler = createStaticHandler(
    "public",
    listDirectories: true,
    useHeaderBytesForContentType: true,
  );

  Response _rootHandler(Request req) {
    return Response.ok('Hello, World! This is Quantum...\n');
  }

  Response _echoHandler(Request request) {
    final message = request.params['message'];
    return Response.ok('$message\n');
  }

  Future<Response> _uploadHandler(Request req) async {
    if (!req.isMultipart) {
      return Response.badRequest();
    }

    try {
      await for (final part in req.parts) {
        final headers = part.headers;

        final data = await part.readBytes();
        final now = DateTime.now();

        final file = File("uploads/${now.millisecondsSinceEpoch}.jpg");

        if (await file.exists()) {
          await file.delete(recursive: true);
        }

        await file.writeAsBytes(data);
      }
    } catch (e) {
      return Response.internalServerError();
    }

    return Response.ok('SUCCESS\n');
  }

  Router _generateRouter() {
    print("--->>> Router requested!");

    return _router
      ..mount(Constants.publicPath, _publicHandler)
      ..mount(Constants.uploadsPath, _uploadsHandler)
      ..get(Constants.rootPath, _rootHandler)
      ..get('${Constants.echoPath}/<message>', _echoHandler)
      ..post(Constants.loginPath, _authController.loginHandler)
      ..post(Constants.signupPath, _authController.signupHandler)
      ..post(Constants.uploadPath, _uploadHandler);
  }

  // GETTERS
  static ServerRoutes get shared => _shared;

  Router get router => _generateRouter();
}
