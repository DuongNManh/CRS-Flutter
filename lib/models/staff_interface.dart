class StaffResponse {
  final String id;
  final String name;
  final String email;
  final String systemRole;
  final String department;

  StaffResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.systemRole,
    required this.department,
  });

  factory StaffResponse.fromJson(Map<String, dynamic> json) => StaffResponse(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    systemRole: json['systemRole'],
    department: json['department'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'systemRole': systemRole,
    'department': department,
  };
}
