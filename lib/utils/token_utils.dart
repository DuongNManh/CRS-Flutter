import 'package:learning_android_1/services/auth_service.dart';

class TokenUtils {
  static Future<bool> isTokenExpired() async {
    final authService = await AuthService.getInstance();
    final expiration = await authService.getTokenExpiration();

    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }
}
