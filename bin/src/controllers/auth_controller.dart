class AuthController {
  static final AuthController _shared = AuthController._instance();

  factory AuthController() => _shared;
  AuthController._instance();
}
