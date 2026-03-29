import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Electronics',
    'Clothing',
    'Food',
    'Books',
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'id': 'P001',
      'name': 'Wireless Headphones',
      'category': 'Electronics',
      'price': 79.99,
      'stock': 45,
      'image': Icons.headphones,
      'color': Colors.blue,
    },
    {
      'id': 'P002',
      'name': 'Running Shoes',
      'category': 'Clothing',
      'price': 129.00,
      'stock': 30,
      'image': Icons.directions_run,
      'color': Colors.green,
    },
    {
      'id': 'P003',
      'name': 'Smart Watch',
      'category': 'Electronics',
      'price': 199.99,
      'stock': 12,
      'image': Icons.watch,
      'color': Colors.purple,
    },
    {
      'id': 'P004',
      'name': 'Coffee Beans',
      'category': 'Food',
      'price': 24.50,
      'stock': 100,
      'image': Icons.coffee,
      'color': Colors.brown,
    },
    {
      'id': 'P005',
      'name': 'Flutter in Action',
      'category': 'Books',
      'price': 39.99,
      'stock': 60,
      'image': Icons.menu_book,
      'color': Colors.orange,
    },
    {
      'id': 'P006',
      'name': 'Bluetooth Speaker',
      'category': 'Electronics',
      'price': 59.99,
      'stock': 8,
      'image': Icons.speaker,
      'color': Colors.teal,
    },
    {
      'id': 'P007',
      'name': 'Winter Jacket',
      'category': 'Clothing',
      'price': 149.00,
      'stock': 25,
      'image': Icons.checkroom,
      'color': Colors.indigo,
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((p) {
      final matchSearch = p['name'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchCat =
          _selectedCategory == 'All' || p['category'] == _selectedCategory;
      return matchSearch && matchCat;
    }).toList();
  }

  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    String selectedCat = 'Electronics';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add New Product'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCat,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .where((c) => c != 'All')
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) =>
                      setDialogState(() => selectedCat = v ?? selectedCat),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    prefixIcon: Icon(Icons.warehouse_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  setState(() {
                    _products.add({
                      'id':
                          'P${(_products.length + 1).toString().padLeft(3, '0')}',
                      'name': nameCtrl.text,
                      'category': selectedCat,
                      'price': double.tryParse(priceCtrl.text) ?? 0.0,
                      'stock': int.tryParse(stockCtrl.text) ?? 0,
                      'image': Icons.inventory_2,
                      'color': Colors.deepPurple,
                    });
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${nameCtrl.text} added!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
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
    final filtered = _filteredProducts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search & filter bar
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // Category chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),

          // Products list
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final p = filtered[i];
                      final isLowStock = (p['stock'] as int) < 10;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: (p['color'] as Color).withOpacity(
                              0.15,
                            ),
                            child: Icon(
                              p['image'] as IconData,
                              color: p['color'] as Color,
                            ),
                          ),
                          title: Text(
                            p['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${p['category']}  •  Stock: ${p['stock']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isLowStock ? Colors.red : Colors.grey,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${(p['price'] as double).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 15,
                                ),
                              ),
                              if (isLowStock)
                                const Text(
                                  'Low stock',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${p['name']} tapped')),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
