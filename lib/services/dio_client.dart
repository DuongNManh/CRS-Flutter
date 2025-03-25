import 'package:dio/dio.dart';
import 'package:learning_android_1/config/api_config.dart';
import 'package:learning_android_1/services/auth_service.dart';

class DioClient {
  static DioClient? _instance;
  late Dio dio;

  // Private constructor
  DioClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    _setupInterceptors();
  }

  // Singleton instance
  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from AuthService
          final authService = await AuthService.getInstance();
          final token = await authService.getToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // // Handle 401 Unauthorized errors
          // if (error.response?.statusCode == 401) {
          //   // Clear token and redirect to login
          //   final authService = await AuthService.getInstance();
          //   await authService.logout();
          //   // Note: You'll need to handle navigation to login screen
          // }
          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (ApiConfig.isDevelopment) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }
}
