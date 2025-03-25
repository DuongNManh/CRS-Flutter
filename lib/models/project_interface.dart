class GetProjectResponse {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final String? projectManager; // Changed to nullable
  final String? description; // Added missing field
  final String? status; // Added missing field
  final double? budget; // Added missing field
  final String? businessUnitLeader; // Added missing field

  GetProjectResponse({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.projectManager,
    this.description,
    this.status,
    this.budget,
    this.businessUnitLeader,
  });

  factory GetProjectResponse.fromJson(Map<String, dynamic> json) {
    return GetProjectResponse(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      projectManager: json['projectManager']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      budget: json['budget']?.toDouble(),
      businessUnitLeader: json['businessUnitLeader']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'projectManager': projectManager,
      'description': description,
      'status': status,
      'budget': budget,
      'businessUnitLeader': businessUnitLeader,
    };
  }
}
