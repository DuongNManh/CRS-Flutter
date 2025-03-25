import 'package:flutter/material.dart';

class StatusColor {
  static const Color draft = Color(0xFFB0BEC5); // Light grey for draft status
  static const Color pending = Color(0xFFFFC107); // Amber for pending status
  static const Color approved = Color(0xFF4CAF50); // Green for approved status
  static const Color canceled = Color(0xFFF44336); // Red for canceled status
  static const Color returned = Color(0xFF2196F3); // Blue for returned status

  // Method to get color based on claim status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return approved;
      case 'Rejected':
        return canceled;
      case 'Pending':
        return pending;
      case 'Draft':
        return draft;
      case 'Returned':
        return returned;
      default:
        return Colors.grey; // Default color for unknown status
    }
  }
}
