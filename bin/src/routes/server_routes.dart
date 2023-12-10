import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../global/constants.dart';

class ServerRoutes {
  static final ServerRoutes _shared = ServerRoutes._instance();

  factory ServerRoutes() => _shared;
  ServerRoutes._instance();

  final _router = Router();

  Response _rootHandler(Request req) {
    return Response.ok('Hello, World! This is Quantum...\n');
  }

  Response _echoHandler(Request request) {
    final message = request.params['message'];
    return Response.ok('$message\n');
  }

  Router _generateRouter() {
    print("--->>> Router requested!");

    return _router
      ..get(Constants.rootPath, _rootHandler)
      ..get('${Constants.echoPath}/<message>', _echoHandler);
  }

  // GETTERS
  static ServerRoutes get shared => _shared;

  Router get router => _generateRouter();
}
