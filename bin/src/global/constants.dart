abstract class Constants {
  static const String kSalt = "p@ssw0rD";

  // API Routes
  static const String rootPath = '/';
  static const String predictionAPI = "localhost:8081/predict";

  static const String adminPath = '/admin';
  static const String publicPath = '/public';
  static const String uploadsPath = '/uploads';

  static const String apiPath = '/api/v1';

  static const String echoPath = '$apiPath/echo';
  static const String loginPath = '$apiPath/login';
  static const String signupPath = '$apiPath/signup';
  static const String addAdminPath = '$apiPath/add-admin';
  static const String uploadPath = '$apiPath/upload';
}
