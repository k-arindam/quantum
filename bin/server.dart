import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'src/routes/server_routes.dart';
import 'src/services/cors_service.dart';

Future<void> main(List<String> args) async => Quantum.startApp();

abstract class Quantum {
  static final _serverRoutes = ServerRoutes.shared;
  static final _ip = InternetAddress.anyIPv4;
  static final _port = int.parse(Platform.environment['PORT'] ?? '8080');

  static Future<void> startApp() async {
    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(CorsService.corsMiddleware)
        .addHandler(_serverRoutes.router);

    await serve(handler, _ip, _port).then(
      (server) {
        print('Server listening on port ${server.port}');
        return server;
      },
      onError: (err, stack) {
        print('Unable to start server --->>> $err');
      },
    );
  }
}
