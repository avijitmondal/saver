import '../models/notification.dart';
import '../constants/app_constants.dart';

class SampleNotifications {
  static List<NotificationModel> getInitialNotifications() {
    // Return empty list if sample data is disabled
    if (!(AppConstants.featureFlags["enableSampleInvestmentData"] ?? false)) {
      return [];
    }
    
    return [
      // Payment Notifications
      NotificationModel(
        title: 'EPF Payment Due',
        message: 'Your monthly EPF contribution of ₹3,500 is due in 3 days.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.payment,
      ),
      NotificationModel(
        title: 'PPF Payment Reminder',
        message: 'Don\'t forget to make your PPF payment for this quarter.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.payment,
      ),
      NotificationModel(
        title: 'RD Auto-Payment Success',
        message: 'Your recurring deposit payment of ₹5,000 was successfully processed.',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        type: NotificationType.payment,
      ),

      // Maturity Notifications
      NotificationModel(
        title: 'FD Maturity Alert',
        message: 'Your HDFC Bank FD of ₹40,000 will mature in 7 days.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.maturity,
      ),
      NotificationModel(
        title: 'RD Maturity',
        message:
            'Your SBI RD will mature next month. Consider renewal options.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.maturity,
        isRead: true,
      ),

      // Interest Rate Notifications
      NotificationModel(
        title: 'EPF Interest Rate Update',
        message: 'EPF interest rate for FY 2023-24 has been set at 8.15%',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        type: NotificationType.interest,
        isRead: true,
      ),
      NotificationModel(
        title: 'FD Rate Alert',
        message: 'HDFC Bank has increased FD rates by 0.25%. Check new rates.',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        type: NotificationType.interest,
        isRead: true,
      ),
      NotificationModel(
        title: 'PPF Interest Rate Change',
        message: 'PPF interest rate remains unchanged at 7.1% for Q1 2024-25.',
        timestamp: DateTime.now().subtract(const Duration(days: 6)),
        type: NotificationType.interest,
      ),

      // General Notifications
      NotificationModel(
        title: 'Portfolio Summary',
        message: 'Your investment portfolio has grown by 12.00% this year.',
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
        type: NotificationType.general,
        isRead: true,
      ),
      NotificationModel(
        title: 'New Feature Available',
        message: 'You can now track your EPF payments history in the app.',
        timestamp: DateTime.now().subtract(const Duration(days: 15)),
        type: NotificationType.general,
        isRead: true,
      ),
      NotificationModel(
        title: 'Tax Saving Reminder',
        message: 'Only 45 days left to make tax-saving investments for FY 2023-24.',
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 14)),
        type: NotificationType.general,
      ),
      NotificationModel(
        title: 'Investment Goal Update',
        message: 'You\'ve reached 75% of your retirement savings goal. Keep it up!',
        timestamp: DateTime.now().subtract(const Duration(days: 9)),
        type: NotificationType.general,
      ),
      
      // Market Updates
      NotificationModel(
        title: 'Market Update',
        message: 'Sensex up by 1.5% today. Your equity-linked investments may be affected positively.',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        type: NotificationType.market,
      ),
      NotificationModel(
        title: 'Gold Price Alert',
        message: 'Gold prices have increased by 3% this month. Consider reviewing your gold investments.',
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
        type: NotificationType.market,
      ),
      
      // Security Alerts
      NotificationModel(
        title: 'Security Alert',
        message: 'We detected a login to your account from a new device. Please verify if it was you.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: NotificationType.security,
      ),
      NotificationModel(
        title: 'Password Changed',
        message: 'Your account password was changed successfully. If this wasn\'t you, please contact support.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        type: NotificationType.security,
        isRead: true,
      ),
    ];
  }
}
