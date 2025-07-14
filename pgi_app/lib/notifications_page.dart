import 'package:flutter/material.dart';

/// Notifications page that displays user notifications
/// This page shows different types of notifications like appointments, reports, system updates, etc.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Sample notification data - in a real app, this would come from an API or database
  // Starting with empty list to show "no notifications yet" state
  final List<NotificationItem> notifications = [];

  @override
  Widget build(BuildContext context) {
    // Separate unread and read notifications
    final unreadNotifications = notifications.where((n) => !n.isRead).toList();
    final readNotifications = notifications.where((n) => n.isRead).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(
          0xFF0F172A,
        ), // Dark theme consistent with app
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Mark all as read button
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white),
            onPressed: () => _markAllAsRead(),
            tooltip: 'Mark all as read',
          ),
          // Clear all notifications button
          IconButton(
            icon: const Icon(Icons.clear_all, color: Colors.white),
            onPressed: () => _showClearAllDialog(),
            tooltip: 'Clear all notifications',
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _refreshNotifications,
              color: Colors.tealAccent,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Unread notifications section
                  if (unreadNotifications.isNotEmpty) ...[
                    _buildSectionHeader(
                      'New Notifications',
                      unreadNotifications.length,
                    ),
                    const SizedBox(height: 8),
                    ...unreadNotifications.map(
                      (notification) =>
                          _buildNotificationCard(notification, isUnread: true),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Read notifications section
                  if (readNotifications.isNotEmpty) ...[
                    _buildSectionHeader('Earlier', readNotifications.length),
                    const SizedBox(height: 8),
                    ...readNotifications.map(
                      (notification) =>
                          _buildNotificationCard(notification, isUnread: false),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  /// Builds the section header with title and count
  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.tealAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds individual notification card
  Widget _buildNotificationCard(
    NotificationItem notification, {
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isUnread ? 4 : 1,
        color: const Color(
          0x1AFFFFFF,
        ), // Semi-transparent white matching app theme
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onNotificationTap(notification),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isUnread
                  ? Border.all(
                      color: Colors.tealAccent.withOpacity(0.5),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification icon based on type
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(
                      notification.type,
                    ).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Notification content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isUnread
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.tealAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds empty state when no notifications
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.white54),
          const SizedBox(height: 16),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'re all caught up!\nNew notifications will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white54, height: 1.4),
          ),
        ],
      ),
    );
  }

  /// Gets the appropriate icon for notification type
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return Icons.calendar_today;
      case NotificationType.report:
        return Icons.description;
      case NotificationType.medication:
        return Icons.medication;
      case NotificationType.system:
        return Icons.system_update;
      case NotificationType.health:
        return Icons.favorite;
    }
  }

  /// Gets the appropriate color for notification type
  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return Colors.blueAccent;
      case NotificationType.report:
        return Colors.orangeAccent;
      case NotificationType.medication:
        return Colors.redAccent;
      case NotificationType.system:
        return Colors.purpleAccent;
      case NotificationType.health:
        return Colors.tealAccent;
    }
  }

  /// Formats timestamp to readable format
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// Handles notification tap
  void _onNotificationTap(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });

    // Show notification details in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Row(
          children: [
            Icon(
              _getNotificationIcon(notification.type),
              color: _getNotificationColor(notification.type),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                notification.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              'Received: ${_formatTimestamp(notification.timestamp)}',
              style: const TextStyle(fontSize: 12, color: Colors.white54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  /// Marks all notifications as read
  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Colors.tealAccent,
      ),
    );
  }

  /// Shows dialog to confirm clearing all notifications
  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text(
          'Clear All Notifications',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllNotifications();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  /// Clears all notifications
  void _clearAllNotifications() {
    setState(() {
      notifications.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications cleared'),
        backgroundColor: Colors.tealAccent,
      ),
    );
  }

  /// Refreshes notifications (simulates API call)
  Future<void> _refreshNotifications() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would fetch new notifications from an API here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications refreshed'),
        backgroundColor: Colors.tealAccent,
        duration: Duration(seconds: 1),
      ),
    );
  }
}

/// Enum for different types of notifications
enum NotificationType { appointment, report, medication, system, health }

/// Model class for notification items
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}
