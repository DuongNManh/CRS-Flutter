import 'package:flutter/material.dart';
import 'package:learning_android_1/utils/token_utils.dart';
import 'package:learning_android_1/services/auth_service.dart';
import 'package:learning_android_1/views/pages/common/login_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuth(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              strokeWidth: 6.0,
            ),
          );
        }

        // If auth check failed, LoginPage will be shown
        if (snapshot.data != true) {
          return const LoginPage();
        }

        return child;
      },
    );
  }

  Future<bool> _checkAuth(BuildContext context) async {
    // Check token expiration
    if (await TokenUtils.isTokenExpired()) {
      final authService = await AuthService.getInstance();
      await authService.logout();

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    // Check if authenticated
    final authService = await AuthService.getInstance();
    return authService.isAuthenticated();
  }
}
