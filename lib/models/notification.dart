import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? category;

  const NotificationModel({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.category,
  });
}

enum NotificationType {
  payment,
  maturity,
  interest,
  general,
  market,
  security,
}

extension NotificationTypeExtension on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.maturity:
        return Icons.event_available;
      case NotificationType.interest:
        return Icons.trending_up;
      case NotificationType.general:
        return Icons.notifications;
      case NotificationType.market:
        return Icons.show_chart;
      case NotificationType.security:
        return Icons.security;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.payment:
        return Colors.blue;
      case NotificationType.maturity:
        return Colors.orange;
      case NotificationType.interest:
        return Colors.green;
      case NotificationType.general:
        return Colors.purple;
      case NotificationType.market:
        return Colors.indigo;
      case NotificationType.security:
        return Colors.red;
    }
  }
}
