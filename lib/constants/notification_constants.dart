import 'package:flutter/material.dart';

class NotificationConstants {
  static const Duration snackBarDuration = Duration(seconds: 2);
  static const double iconSize = 64.0;
  static const double avatarSize = 40.0;
  static const double headerHeight = 56.0;
  static const double cardElevation = 2.0;
  static const double cardSpacing = 8.0;
  static const double contentPadding = 16.0;
  static const double titleFontSize = 20.0;
  static const double subtitleFontSize = 16.0;
  static const double timestampFontSize = 12.0;

  static const EdgeInsets listPadding = EdgeInsets.only(
    top: 72,
    bottom: 16,
    left: 16,
    right: 16,
  );

  static const EdgeInsets headerPadding = EdgeInsets.symmetric(horizontal: 16);

  // Text Strings
  static const String noNotificationsTitle = 'No Notifications';
  static const String markAllAsReadButton = 'Mark all as read';
  static const String clearAllTitle = 'Clear All Notifications';
  static const String clearAllMessage =
      'Are you sure you want to clear all notifications? This action cannot be undone.';
  static const String cancelButton = 'CANCEL';
  static const String clearButton = 'CLEAR';

  // SnackBar Messages
  static const String notificationRemovedMessage = 'Notification removed';
  static const String allMarkedAsReadMessage =
      'All notifications marked as read';
  static const String allClearedMessage = 'All notifications cleared';
}
