import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'New Order Received',
      'body': 'Order #1239 from Mark Wilson — \$250.00',
      'time': 'Just now',
      'icon': Icons.shopping_bag,
      'color': Colors.blue,
      'isRead': false,
    },
    {
      'id': 2,
      'title': 'Payment Confirmed',
      'body': 'Payment of \$310.75 from Eva Green confirmed.',
      'time': '15 min ago',
      'icon': Icons.payment,
      'color': Colors.green,
      'isRead': false,
    },
    {
      'id': 3,
      'title': 'Low Stock Alert',
      'body': 'Bluetooth Speaker has only 8 units left.',
      'time': '1 hour ago',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.orange,
      'isRead': false,
    },
    {
      'id': 4,
      'title': 'New Customer Registered',
      'body': 'Grace Kim just created an account.',
      'time': '3 hours ago',
      'icon': Icons.person_add,
      'color': Colors.purple,
      'isRead': true,
    },
    {
      'id': 5,
      'title': 'Order Cancelled',
      'body': 'Order #1238 was cancelled by Eva Green.',
      'time': '1 day ago',
      'icon': Icons.cancel_outlined,
      'color': Colors.red,
      'isRead': true,
    },
    {
      'id': 6,
      'title': 'New Review Posted',
      'body': 'Alice Johnson gave 5 stars for Wireless Headphones.',
      'time': '2 days ago',
      'icon': Icons.star,
      'color': Colors.amber,
      'isRead': true,
    },
    {
      'id': 7,
      'title': 'Monthly Report Ready',
      'body': 'Your February performance report is ready to view.',
      'time': '3 days ago',
      'icon': Icons.bar_chart,
      'color': Colors.teal,
      'isRead': true,
    },
  ];

  int get _unreadCount =>
      _notifications.where((n) => !(n['isRead'] as bool)).length;

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n['isRead'] = true;
      }
    });
  }

  void _markRead(int id) {
    setState(() {
      final n = _notifications.firstWhere((n) => n['id'] == id);
      n['isRead'] = true;
    });
  }

  void _deleteNotification(int id) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final unread = _notifications.where((n) => !(n['isRead'] as bool)).toList();
    final read = _notifications.where((n) => n['isRead'] as bool).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifications'),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  '$_unreadCount',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Mark all read',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none,
                      size: 72, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  const Text('No notifications',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                if (unread.isNotEmpty) ...[
                  _sectionHeader('New'),
                  ...unread.map((n) => _buildNotificationTile(n)),
                ],
                if (read.isNotEmpty) ...[
                  _sectionHeader('Earlier'),
                  ...read.map((n) => _buildNotificationTile(n)),
                ],
              ],
            ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> n) {
    final isRead = n['isRead'] as bool;
    return Dismissible(
      key: Key(n['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => _deleteNotification(n['id'] as int),
      child: InkWell(
        onTap: () => _markRead(n['id'] as int),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : Colors.deepPurple.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isRead
                    ? Colors.grey.shade200
                    : Colors.deepPurple.withOpacity(0.2)),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundColor:
                      (n['color'] as Color).withOpacity(0.15),
                  child: Icon(n['icon'] as IconData,
                      color: n['color'] as Color, size: 20),
                ),
                if (!isRead)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Colors.deepPurple, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
            title: Text(
              n['title'] as String,
              style: TextStyle(
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Text(n['body'] as String,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            trailing: Text(n['time'] as String,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ),
        ),
      ),
    );
  }
}
