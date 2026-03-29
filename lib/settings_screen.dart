import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _orderAlerts = true;
  bool _stockAlerts = false;
  bool _weeklyReports = true;
  String _currency = 'USD';
  String _language = 'English';

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'THB', 'JPY'];
  final List<String> _languages = ['English', 'Thai', 'Japanese', 'French', 'Spanish'];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Profile section
          _sectionHeader('Account'),
          _buildProfileCard(primary),

          // Appearance
          _sectionHeader('Appearance'),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            iconColor: Colors.indigo,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: _darkMode,
            onChanged: (v) {
              setState(() => _darkMode = v);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dark mode coming soon!')),
              );
            },
          ),
          _buildDropdownTile(
            icon: Icons.language,
            iconColor: Colors.blue,
            title: 'Language',
            value: _language,
            items: _languages,
            onChanged: (v) => setState(() => _language = v!),
          ),
          _buildDropdownTile(
            icon: Icons.attach_money,
            iconColor: Colors.green,
            title: 'Currency',
            value: _currency,
            items: _currencies,
            onChanged: (v) => setState(() => _currency = v!),
          ),

          // Notifications
          _sectionHeader('Notifications'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            iconColor: Colors.orange,
            title: 'Push Notifications',
            subtitle: 'Receive push alerts on your device',
            value: _pushNotifications,
            onChanged: (v) => setState(() => _pushNotifications = v),
          ),
          _buildSwitchTile(
            icon: Icons.email_outlined,
            iconColor: Colors.teal,
            title: 'Email Notifications',
            subtitle: 'Get updates sent to your email',
            value: _emailNotifications,
            onChanged: (v) => setState(() => _emailNotifications = v),
          ),
          _buildSwitchTile(
            icon: Icons.shopping_bag_outlined,
            iconColor: Colors.blue,
            title: 'Order Alerts',
            subtitle: 'Notify on new or cancelled orders',
            value: _orderAlerts,
            onChanged: (v) => setState(() => _orderAlerts = v),
          ),
          _buildSwitchTile(
            icon: Icons.warehouse_outlined,
            iconColor: Colors.red,
            title: 'Low Stock Alerts',
            subtitle: 'Alert when products run low',
            value: _stockAlerts,
            onChanged: (v) => setState(() => _stockAlerts = v),
          ),
          _buildSwitchTile(
            icon: Icons.bar_chart,
            iconColor: Colors.purple,
            title: 'Weekly Reports',
            subtitle: 'Receive summary every Monday',
            value: _weeklyReports,
            onChanged: (v) => setState(() => _weeklyReports = v),
          ),

          // Privacy & Security
          _sectionHeader('Privacy & Security'),
          _buildNavTile(
            icon: Icons.lock_outline,
            iconColor: Colors.grey,
            title: 'Change Password',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change Password'))),
          ),
          _buildNavTile(
            icon: Icons.security,
            iconColor: Colors.grey,
            title: 'Two-Factor Authentication',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('2FA coming soon'))),
          ),
          _buildNavTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: Colors.grey,
            title: 'Privacy Policy',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy Policy'))),
          ),

          // Support
          _sectionHeader('Support'),
          _buildNavTile(
            icon: Icons.help_outline,
            iconColor: Colors.blue,
            title: 'Help Center',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help Center'))),
          ),
          _buildNavTile(
            icon: Icons.feedback_outlined,
            iconColor: Colors.green,
            title: 'Send Feedback',
            onTap: () => _showFeedbackDialog(),
          ),
          _buildNavTile(
            icon: Icons.info_outline,
            iconColor: Colors.grey,
            title: 'About',
            trailing: const Text('v1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Branh App',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2025 Branh',
            ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
              onPressed: () =>
                  Navigator.of(context).popUntil((r) => r.isFirst),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Color primary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: primary.withOpacity(0.15),
            child: Icon(Icons.person, color: primary, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Admin User',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('admin@branh.app',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile'))),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(title.toUpperCase(),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              letterSpacing: 1.2)),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: CircleAvatar(
          radius: 18,
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        subtitle:
            subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 11)) : null,
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: DropdownButton<String>(
          value: value,
          underline: const SizedBox(),
          items:
              items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          style: const TextStyle(color: Colors.black87, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: trailing ??
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }

  void _showFeedbackDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Send Feedback'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Tell us what you think...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Thank you for your feedback!'),
                    backgroundColor: Colors.green),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
