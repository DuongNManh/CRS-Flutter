import 'package:learning_android_1/models/staff_interface.dart';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class LoginResponse {
  final String token;
  final StaffResponse user;
  final DateTime expiration;

  LoginResponse({
    required this.token,
    required this.user,
    required this.expiration,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json['token'],
    user: StaffResponse.fromJson(json['user']),
    expiration: DateTime.parse(json['expiration']),
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'user': user.toJson(),
    'expiration': expiration.toIso8601String(),
  };
}
