import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'C001',
      'name': 'Alice Johnson',
      'email': 'alice@example.com',
      'phone': '+1 555-0101',
      'orders': 12,
      'totalSpent': 1450.00,
      'status': 'Active',
      'avatarColor': Colors.blue,
    },
    {
      'id': 'C002',
      'name': 'Bob Smith',
      'email': 'bob@example.com',
      'phone': '+1 555-0102',
      'orders': 5,
      'totalSpent': 320.50,
      'status': 'Active',
      'avatarColor': Colors.green,
    },
    {
      'id': 'C003',
      'name': 'Carol White',
      'email': 'carol@example.com',
      'phone': '+1 555-0103',
      'orders': 23,
      'totalSpent': 3200.00,
      'status': 'VIP',
      'avatarColor': Colors.purple,
    },
    {
      'id': 'C004',
      'name': 'David Brown',
      'email': 'david@example.com',
      'phone': '+1 555-0104',
      'orders': 2,
      'totalSpent': 90.00,
      'status': 'Inactive',
      'avatarColor': Colors.orange,
    },
    {
      'id': 'C005',
      'name': 'Eva Green',
      'email': 'eva@example.com',
      'phone': '+1 555-0105',
      'orders': 18,
      'totalSpent': 2150.75,
      'status': 'VIP',
      'avatarColor': Colors.teal,
    },
    {
      'id': 'C006',
      'name': 'Frank Lee',
      'email': 'frank@example.com',
      'phone': '+1 555-0106',
      'orders': 7,
      'totalSpent': 560.00,
      'status': 'Active',
      'avatarColor': Colors.red,
    },
  ];

  List<Map<String, dynamic>> get _filtered => _customers.where((c) {
        final q = _searchQuery.toLowerCase();
        return c['name'].toString().toLowerCase().contains(q) ||
            c['email'].toString().toLowerCase().contains(q);
      }).toList();

  Color _statusColor(String status) {
    switch (status) {
      case 'VIP':
        return Colors.purple;
      case 'Active':
        return Colors.green;
      case 'Inactive':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showCustomerDetail(Map<String, dynamic> c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: (c['avatarColor'] as Color).withOpacity(0.2),
              child: Text(
                (c['name'] as String)[0],
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: c['avatarColor'] as Color,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(c['name'] as String,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Chip(
              label: Text(c['status'] as String,
                  style: TextStyle(color: _statusColor(c['status'] as String))),
              backgroundColor:
                  _statusColor(c['status'] as String).withOpacity(0.1),
              side: BorderSide.none,
            ),
            const SizedBox(height: 16),
            _detailRow(Icons.email_outlined, c['email'] as String),
            _detailRow(Icons.phone_outlined, c['phone'] as String),
            _detailRow(Icons.shopping_bag_outlined,
                '${c['orders']} orders'),
            _detailRow(Icons.attach_money,
                '\$${(c['totalSpent'] as double).toStringAsFixed(2)} total spent'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.email),
                    label: const Text('Email'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.message),
                    label: const Text('Message'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text('${_customers.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
              backgroundColor: Colors.white24,
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats banner
          Container(
            color: primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _statBadge('Total', '${_customers.length}', Colors.white),
                const SizedBox(width: 8),
                _statBadge(
                    'VIP',
                    '${_customers.where((c) => c['status'] == 'VIP').length}',
                    Colors.amber),
                const SizedBox(width: 8),
                _statBadge(
                    'Active',
                    '${_customers.where((c) => c['status'] == 'Active').length}',
                    Colors.greenAccent),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child:
                        Text('No customers found', style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final c = filtered[i];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: ListTile(
                          onTap: () => _showCustomerDetail(c),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          leading: CircleAvatar(
                            backgroundColor:
                                (c['avatarColor'] as Color).withOpacity(0.2),
                            child: Text(
                              (c['name'] as String)[0],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: c['avatarColor'] as Color),
                            ),
                          ),
                          title: Text(c['name'] as String,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(c['email'] as String,
                              style: const TextStyle(fontSize: 12)),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Chip(
                                label: Text(c['status'] as String,
                                    style: TextStyle(
                                        color: _statusColor(c['status'] as String),
                                        fontSize: 10)),
                                backgroundColor:
                                    _statusColor(c['status'] as String).withOpacity(0.1),
                                side: BorderSide.none,
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Text('${c['orders']} orders',
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                            ],
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

  Widget _statBadge(String label, String count, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(20)),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: '$count ',
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            TextSpan(
                text: label,
                style: const TextStyle(color: Colors.white60, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
