import 'package:flutter/material.dart';

class GroceryItem {
  GroceryItem({required this.id, required this.name, this.selected = false});

  final String id;
  final String name;
  bool selected;
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<String> _pool = const [
    'Apples',
    'Bananas',
    'Bread',
    'Milk',
    'Eggs',
    'Cheese',
    'Tomatoes',
    'Lettuce',
    'Chicken',
    'Rice',
    'Pasta',
    'Yogurt',
    'Orange juice',
    'Cereal',
    'Butter',
    'Onions',
    'Potatoes',
    'Carrots',
    'Coffee',
    'Tea',
  ];

  final List<GroceryItem> _items = [];

  @override
  void initState() {
    super.initState();
  }


  void _removeItem(String id) {
    setState(() {
      _items.removeWhere((it) => it.id == id);
    });
  }

  void _toggleSelected(int index, bool? value) {
    setState(() => _items[index].selected = value ?? false);
  }

  Future<void> _showAddGroceryDialog() async {
    // build a list of available names (skip already added)
    final existingNames = _items.map((e) => e.name).toSet();
    final available = _pool.where((name) => !existingNames.contains(name)).toList();
    if (available.isEmpty) {
      // nothing to add
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All groceries already added')));
      return;
    }

    // selection state inside dialog
    final Map<String, bool> selected = {for (var n in available) n: false};

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          final anySelected = selected.values.any((v) => v);
          return AlertDialog(
            title: const Text('Select groceries to add'),
            content: SizedBox(
              width: double.maxFinite,
              height: 320,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: available.length,
                  itemBuilder: (context, index) {
                    final name = available[index];
                    return CheckboxListTile(
                      value: selected[name],
                      title: Text(name),
                      onChanged: (v) => setStateDialog(() => selected[name] = v ?? false),
                    );
                  },
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              TextButton(
                onPressed: anySelected
                    ? () {
                        final chosen = selected.entries.where((e) => e.value).map((e) => e.key).toList();
                        setState(() {
                          for (var name in chosen) {
                            // create unique id
                            final id = '${name.replaceAll(' ', '_')}_${DateTime.now().microsecondsSinceEpoch}';
                            _items.add(GroceryItem(id: id, name: name));
                          }
                        });
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: _showAddGroceryDialog,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add Grocery'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_items.length} item${_items.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _items.isEmpty
              ? const Center(child: Text('No items — tap "Add Grocery" to add some.'))
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      key: ValueKey(item.id),
                      leading: Checkbox(
                        value: item.selected,
                        onChanged: (v) => _toggleSelected(index, v),
                      ),
                      title: Text(item.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeItem(item.id),
                        tooltip: 'Delete',
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

