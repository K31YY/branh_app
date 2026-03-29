// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'products_screen.dart';
import 'customers_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String? userName;
  const DashboardScreen({Key? key, this.userName}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Sample activity data
  final List<Map<String, dynamic>> _activities = [
    {
      'icon': Icons.person_add,
      'color': Colors.blue,
      'title': 'New user registered',
      'time': '2 hours ago',
    },
    {
      'icon': Icons.shopping_bag,
      'color': Colors.green,
      'title': 'Order #1234 completed',
      'time': '5 hours ago',
    },
    {
      'icon': Icons.payment,
      'color': Colors.orange,
      'title': 'Payment received',
      'time': '1 day ago',
    },
    {
      'icon': Icons.star,
      'color': Colors.purple,
      'title': 'New review posted',
      'time': '2 days ago',
    },
  ];

  // Quick action buttons
  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.inventory_2_outlined, 'label': 'Products', 'color': Colors.blue},
    {'icon': Icons.people, 'label': 'Customers', 'color': Colors.green},
    {'icon': Icons.bar_chart, 'label': 'Reports', 'color': Colors.orange},
    {'icon': Icons.settings, 'label': 'Settings', 'color': Colors.purple},
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${widget.userName ?? 'User'}!',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(theme),
          _buildOrdersTab(),
          _buildReportsTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // ─── HOME TAB ───────────────────────────────────────────────────────────────

  Widget _buildHomeTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary banner
          _buildSummaryBanner(theme),
          const SizedBox(height: 20),

          // Stats Grid
          const Text(
            'Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard(
                'Total Users', '1,234', Icons.people, Colors.blue,
              ),
              _buildStatCard(
                'Revenue', '\$12,500', Icons.attach_money, Colors.green,
              ),
              _buildStatCard(
                'Orders', '456', Icons.shopping_bag, Colors.orange,
              ),
              _buildStatCard(
                'Growth', '+23%', Icons.trending_up, Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _quickActions
                .map((action) => _buildQuickAction(action))
                .toList(),
          ),
          const SizedBox(height: 20),

          // Recent Activity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('View all activity')),
                  );
                },
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _activities.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) =>
                  _buildActivityItem(_activities[index]),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummaryBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Summary",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '\$3,240.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 16),
              SizedBox(width: 4),
              Text(
                '12% vs yesterday',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 18),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () {
        final label = action['label'] as String;
        if (label == 'Products') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProductsScreen()));
        } else if (label == 'Customers') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CustomersScreen()));
        } else if (label == 'Settings') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()));
        } else {
          setState(() => _selectedIndex = 2); // go to Reports tab
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: (action['color'] as Color).withOpacity(0.15),
            child: Icon(action['icon'] as IconData,
                color: action['color'] as Color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            action['label'] as String,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (activity['color'] as Color).withOpacity(0.15),
        child: Icon(activity['icon'] as IconData,
            color: activity['color'] as Color, size: 20),
      ),
      title: Text(activity['title'] as String,
          style: const TextStyle(fontSize: 14)),
      trailing: Text(
        activity['time'] as String,
        style: const TextStyle(color: Colors.grey, fontSize: 11),
      ),
    );
  }

  // ─── ORDERS TAB ─────────────────────────────────────────────────────────────

  Widget _buildOrdersTab() {
    final orders = [
      {'id': '#1234', 'customer': 'Alice Johnson', 'amount': '\$120.00', 'status': 'Completed'},
      {'id': '#1235', 'customer': 'Bob Smith', 'amount': '\$85.50', 'status': 'Pending'},
      {'id': '#1236', 'customer': 'Carol White', 'amount': '\$200.00', 'status': 'Processing'},
      {'id': '#1237', 'customer': 'David Brown', 'amount': '\$45.00', 'status': 'Completed'},
      {'id': '#1238', 'customer': 'Eva Green', 'amount': '\$310.75', 'status': 'Cancelled'},
    ];

    Color statusColor(String status) {
      switch (status) {
        case 'Completed': return Colors.green;
        case 'Pending': return Colors.orange;
        case 'Processing': return Colors.blue;
        case 'Cancelled': return Colors.red;
        default: return Colors.grey;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Orders',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.withOpacity(0.1),
                      child: const Icon(Icons.shopping_bag,
                          color: Colors.deepPurple),
                    ),
                    title: Text('${order['id']} — ${order['customer']}'),
                    subtitle: Text(order['amount']!),
                    trailing: Chip(
                      label: Text(
                        order['status']!,
                        style: TextStyle(
                            color: statusColor(order['status']!),
                            fontSize: 11),
                      ),
                      backgroundColor:
                          statusColor(order['status']!).withOpacity(0.1),
                      side: BorderSide.none,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── REPORTS TAB ────────────────────────────────────────────────────────────

  Widget _buildReportsTab() {
    final metrics = [
      {'label': 'Total Sales', 'value': '\$45,230', 'change': '+8%', 'up': true},
      {'label': 'New Customers', 'value': '312', 'change': '+15%', 'up': true},
      {'label': 'Avg. Order Value', 'value': '\$99.20', 'change': '-3%', 'up': false},
      {'label': 'Return Rate', 'value': '4.2%', 'change': '-1%', 'up': true},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reports',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final m = metrics[index];
              final isUp = m['up'] as bool;
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m['label'] as String,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      Text(m['value'] as String,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(
                            isUp ? Icons.arrow_upward : Icons.arrow_downward,
                            size: 14,
                            color: isUp ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            m['change'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isUp ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('Monthly Performance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(6, (i) {
                  final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                  final values = [0.6, 0.8, 0.5, 0.9, 0.7, 1.0];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 36,
                            child: Text(months[i],
                                style: const TextStyle(fontSize: 12))),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: values[i],
                              minHeight: 14,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${(values[i] * 10000).toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── PROFILE TAB ────────────────────────────────────────────────────────────

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.deepPurple.withOpacity(0.15),
            child: const Icon(Icons.person, size: 52, color: Colors.deepPurple),
          ),
          const SizedBox(height: 12),
          Text(
            widget.userName ?? 'User',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text('Admin', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          _buildProfileOption(Icons.edit, 'Edit Profile', () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Edit Profile')));
          }),
          _buildProfileOption(Icons.lock_outline, 'Change Password', () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change Password')));
          }),
          _buildProfileOption(Icons.notifications_outlined, 'Notifications', () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications settings')));
          }),
          _buildProfileOption(Icons.help_outline, 'Help & Support', () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Help & Support')));
          }),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Logout',
                  style: TextStyle(color: Colors.red, fontSize: 16)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
      IconData icon, String label, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(label),
        trailing:
            const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
