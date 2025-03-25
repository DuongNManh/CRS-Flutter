import 'package:learning_android_1/models/project_interface.dart';
import 'package:learning_android_1/models/staff_interface.dart';

class GetClaimResponse {
  final String id;
  final String name;
  final GetProjectResponse? project;
  final StaffResponse? claimer;
  final String status;
  final double totalWorkingHours;
  final double amount;
  final String createAt;
  final ClaimApproverResponse? claimApprover;

  GetClaimResponse({
    required this.id,
    required this.name,
    this.project,
    this.claimer,
    required this.status,
    required this.totalWorkingHours,
    required this.amount,
    required this.createAt,
    this.claimApprover,
  });

  factory GetClaimResponse.fromJson(Map<String, dynamic> json) {
    return GetClaimResponse(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      project:
          json['project'] != null
              ? GetProjectResponse.fromJson(json['project'])
              : null,
      claimer:
          json['claimer'] != null
              ? StaffResponse.fromJson(json['claimer'])
              : null,
      status: json['status']?.toString() ?? '',
      totalWorkingHours: (json['totalWorkingHours'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      createAt: json['createAt']?.toString() ?? '',
      claimApprover:
          json['claimApprover'] != null
              ? ClaimApproverResponse.fromJson(json['claimApprover'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'project': project?.toJson(),
      'claimer': claimer?.toJson(),
      'status': status,
      'totalWorkingHours': totalWorkingHours,
      'amount': amount,
      'createAt': createAt,
      'claimApprover': claimApprover?.toJson(),
    };
  }
}

class ClaimDetailResponse {
  final String id;
  final String name;
  final double amount;
  final String remark;
  final String createAt;
  final double totalWorkingHours;
  final String startDate;
  final String endDate;
  final String claimType;
  final String status;
  final List<ClaimApproverResponse> claimApprovers;
  final GetProjectResponse? project;
  final List<ClaimChangeLogResponse> changeHistory;
  final StaffResponse? finance;
  final StaffResponse? claimer;

  ClaimDetailResponse({
    required this.id,
    required this.name,
    required this.amount,
    required this.remark,
    required this.createAt,
    required this.totalWorkingHours,
    required this.startDate,
    required this.endDate,
    required this.claimType,
    required this.status,
    required this.claimApprovers,
    this.project,
    required this.changeHistory,
    this.finance,
    required this.claimer,
  });

  factory ClaimDetailResponse.fromJson(Map<String, dynamic> json) {
    return ClaimDetailResponse(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      remark: json['remark']?.toString() ?? '',
      createAt: json['createAt']?.toString() ?? '',
      totalWorkingHours: (json['totalWorkingHours'] ?? 0.0).toDouble(),
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      claimType: json['claimType']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      claimApprovers:
          (json['claimApprovers'] as List?)
              ?.map((i) => ClaimApproverResponse.fromJson(i))
              .toList() ??
          [],
      project:
          json['project'] != null
              ? GetProjectResponse.fromJson(json['project'])
              : null,
      changeHistory:
          (json['changeHistory'] as List?)
              ?.map((i) => ClaimChangeLogResponse.fromJson(i))
              .toList() ??
          [],
      finance:
          json['finance'] != null
              ? StaffResponse.fromJson(json['finance'])
              : null,
      claimer:
          json['claimer'] != null
              ? StaffResponse.fromJson(json['claimer'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'remark': remark,
      'createAt': createAt,
      'totalWorkingHours': totalWorkingHours,
      'startDate': startDate,
      'endDate': endDate,
      'claimType': claimType,
      'status': status,
      'claimApprovers': claimApprovers.map((i) => i.toJson()).toList(),
      'project': project?.toJson(),
      'changeHistory': changeHistory.map((i) => i.toJson()).toList(),
      'finance': finance?.toJson(),
      'claimer': claimer?.toJson(),
    };
  }
}

class ClaimChangeLogResponse {
  final String message;
  final String changedAt;
  final String changedBy;

  ClaimChangeLogResponse({
    required this.message,
    required this.changedAt,
    required this.changedBy,
  });

  factory ClaimChangeLogResponse.fromJson(Map<String, dynamic> json) {
    return ClaimChangeLogResponse(
      message: json['message']?.toString() ?? '',
      changedAt: json['changedAt']?.toString() ?? '',
      changedBy: json['changedBy']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'changedAt': changedAt, 'changedBy': changedBy};
  }
}

class ClaimApproverResponse {
  final String name;
  final String approverStatus;
  final String decisionAt;

  ClaimApproverResponse({
    required this.name,
    required this.approverStatus,
    required this.decisionAt,
  });

  factory ClaimApproverResponse.fromJson(Map<String, dynamic> json) {
    return ClaimApproverResponse(
      name: json['name']?.toString() ?? '',
      approverStatus: json['approverStatus']?.toString() ?? '',
      decisionAt: json['decisionAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'approverStatus': approverStatus,
      'decisionAt': decisionAt,
    };
  }
}

class ClaimStatusCountResponse {
  final int total;
  final int pending;
  final int approved;
  final int rejected;
  final int draft;
  final int paid;
  final int cancelled;

  ClaimStatusCountResponse({
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.draft,
    required this.paid,
    required this.cancelled,
  });

  factory ClaimStatusCountResponse.fromJson(Map<String, dynamic> json) {
    return ClaimStatusCountResponse(
      total: json['total'],
      pending: json['pending'],
      approved: json['approved'],
      rejected: json['rejected'],
      draft: json['draft'],
      paid: json['paid'],
      cancelled: json['cancelled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'pending': pending,
      'approved': approved,
      'rejected': rejected,
      'draft': draft,
      'paid': paid,
      'cancelled': cancelled,
    };
  }
}
