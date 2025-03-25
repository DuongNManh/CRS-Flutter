class ApiConfig {
  // Base URLs
  static const String devBaseUrl = 'https://localhost:5001/api/v1/';
  static const String prodBaseUrl = 'https://crsojt.azurewebsites.net/api/v1/';

  // Environment detection
  static bool get isDevelopment {
    // You can expand this logic based on your needs
    return const bool.fromEnvironment('dart.vm.product') == false;
  }

  // Current base URL
  static String get baseUrl {
    // return isDevelopment ? devBaseUrl : prodBaseUrl;
    return prodBaseUrl;
  }

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  // Add other endpoints as needed
}
