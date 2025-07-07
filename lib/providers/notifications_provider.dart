import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../data/sample_notifications.dart';

class NotificationsProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications =
      SampleNotifications.getInitialNotifications();

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  List<NotificationModel> get unreadNotifications =>
      _notifications.where((notification) => !notification.isRead).toList();

  int get unreadCount => unreadNotifications.length;

  void markAsRead(NotificationModel notification) {
    final index = _notifications.indexOf(notification);
    if (index != -1) {
      _notifications[index] = NotificationModel(
        title: notification.title,
        message: notification.message,
        timestamp: notification.timestamp,
        type: notification.type,
        isRead: true,
      );
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      final notification = _notifications[i];
      _notifications[i] = NotificationModel(
        title: notification.title,
        message: notification.message,
        timestamp: notification.timestamp,
        type: notification.type,
        isRead: true,
      );
    }
    notifyListeners();
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void removeNotification(NotificationModel notification) {
    _notifications.remove(notification);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
