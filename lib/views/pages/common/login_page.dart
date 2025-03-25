import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:learning_android_1/data/constants.dart';
import 'package:learning_android_1/views/widget_tree.dart';
import 'package:learning_android_1/services/auth_service.dart';
import 'package:learning_android_1/views/widgets/auth_guard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // You can add TextEditingControllers for username and password if needed
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isDuongDeepTry = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(6, 7, 6, 9),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Image.asset(
                          'assets/images/HaiCau.jpg',
                          width: 220,
                          fit:
                              BoxFit
                                  .cover, // Ensures the image covers the container
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Container(
                    height: 12, // Set a small height to resemble a keyboard
                    width: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  Text('Login', style: AppTextStyle.h2),
                  SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: usernameController,
                    style: AppTextStyle.input,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: AppTextStyle.label,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: passwordController,
                    style: AppTextStyle.input,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: AppTextStyle.label,
                    ),
                    obscureText: true, // Hide password input
                  ),
                  SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: () {
                      handleLogin();
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: AppSpacing.md),
                  CheckboxListTile.adaptive(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    title: Text(
                      'Accept that Duong is deep try',
                      style: AppTextStyle.bodyMedium,
                    ),
                    value: isDuongDeepTry,
                    onChanged: (bool? value) {
                      setState(() {
                        isDuongDeepTry = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Add a method to handle login
  void handleLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Error', style: AppTextStyle.h3),
              content: Text(
                'Please fill in all fields',
                style: AppTextStyle.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK', style: AppTextStyle.buttonMedium),
                ),
              ],
            ),
      );
      return;
    }
    if (!isDuongDeepTry) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Error', style: AppTextStyle.h3),
              content: Text(
                'You must accept the truth',
                style: AppTextStyle.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK', style: AppTextStyle.buttonMedium),
                ),
              ],
            ),
      );
      return;
    }

    try {
      final authService = await AuthService.getInstance();
      final response = await authService.login(
        usernameController.text,
        passwordController.text,
      );

      if (response.isSuccess && response.data != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthGuard(child: WidgetTree()),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.reason ?? 'Failed to login'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }
}
