import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notifications_provider.dart';
import '../models/notification.dart';
import '../widgets/common/app_scaffold.dart';
import '../constants/ui_constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (context, notificationsProvider, child) {
        final notifications = notificationsProvider.notifications;
        final unreadCount = notificationsProvider.unreadCount;

        // Create the app bar actions
        final List<Widget> actions = [
          TextButton(
            onPressed: () {
              notificationsProvider.markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                  behavior: SnackBarBehavior.floating,
                  duration: UIConstants.animationDurationMedium,
                ),
              );
            },
            child: const Text('Mark all as read'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear All Notifications'),
                  content: const Text(
                    'Are you sure you want to clear all notifications? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        notificationsProvider.clearAll();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All notifications cleared'),
                            behavior: SnackBarBehavior.floating,
                            duration: UIConstants.animationDurationMedium,
                          ),
                        );
                      },
                      child: const Text('CLEAR'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ];

        return AppScaffold(
          title: unreadCount > 0
              ? 'Notifications ($unreadCount)'
              : 'Notifications',
          actions: notifications.isEmpty ? null : actions,
          body: notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: UIConstants.spacing16),
                      Text(
                        'No Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Dismissible(
                      key: Key(notification.timestamp.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        notificationsProvider.removeNotification(notification);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification removed'),
                            behavior: SnackBarBehavior.floating,
                            duration: UIConstants.animationDurationMedium,
                          ),
                        );
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding:
                            const EdgeInsets.only(right: UIConstants.spacing16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(UIConstants.radiusMedium),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                      child: Card(
                        elevation: notification.isRead
                            ? 0
                            : UIConstants.elevationSmall,
                        color: notification.isRead
                            ? Colors.white
                            : Colors.blue.shade50,
                        margin:
                            const EdgeInsets.only(bottom: UIConstants.spacing8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                notification.type.color.withOpacity(0.1),
                            child: Icon(
                              notification.type.icon,
                              color: notification.type.color,
                            ),
                          ),
                          title: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: UIConstants.spacing4),
                              Text(notification.message),
                              const SizedBox(height: UIConstants.spacing4),
                              Text(
                                _getTimeAgo(notification.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (!notification.isRead) {
                              notificationsProvider.markAsRead(notification);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
