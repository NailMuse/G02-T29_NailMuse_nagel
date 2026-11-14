// src/lib/features/inventory/screens/inventory_screen.dart
// FR-07 Inventory Management | GitHub Issue #19 | UI-10 Inventory (owner view) | Test case TC-FR07-01
// Branch: feature/FR-07-inventory | Owner bottom bar tab: "Inventory"
//
// Acceptance criteria (Issue #19):
//  1. The owner can add new nail supplies          -> "Add item" button
//  2. The owner can record the quantity of each    -> quantity field in the add form
//  3. The owner can update inventory quantities    -> - and + buttons on each item
//  4. The owner can view the current stock         -> the list
//  5. The system shows updated quantities          -> list refreshes with setState
//
// Colours and fonts come from the shared theme (AppTheme.light in core/theme/app_theme.dart:
// Night Bordeaux / Cool Horizon / Ivory Mist, Lora + Poppins), so this screen looks the same as the others.
// Data comes from AppProvider.inventory
// (which reads MockData.inventoryItems in mock_data.dart).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/enums.dart';
import '../../../models/inventory_item_model.dart';
import '../../../providers/app_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  Future<void> _openAddSheet() async {
    final newItem = await showModalBottomSheet<InventoryItemModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddItemSheet(),
    );
    if (newItem == null || !mounted) return;
    context.read<AppProvider>().addInventoryItem(newItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${newItem.itemName} added to stock.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = context.watch<AppProvider>();
    final items = provider.inventory;
    final lowCount = items.where((i) => i.isLowStock).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Column(
        children: [
          if (lowCount > 0)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lowCount == 1
                          ? '1 item is low in stock'
                          : '$lowCount items are low in stock',
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No supplies yet. Tap "Add item".'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return _ItemCard(
                        item: item,
                        onMinus: () =>
                            context.read<AppProvider>().updateInventoryQuantity(
                              item.itemId,
                              item.itemQuantity - 1,
                            ),
                        onPlus: () =>
                            context.read<AppProvider>().updateInventoryQuantity(
                              item.itemId,
                              item.itemQuantity + 1,
                            ),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: cs.primary,
                  side: BorderSide(color: cs.primary),
                ),
                onPressed: _openAddSheet,
                child: const Text('Add item'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final InventoryItemModel item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  const _ItemCard({
    required this.item,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        item.itemCategory,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Min ${item.itemMinThreshold}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (item.isLowStock)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: cs.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Low stock',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Remove one',
              icon: const Icon(Icons.remove_circle_outline),
              color: cs.primary,
              onPressed: item.itemQuantity == 0 ? null : onMinus,
            ),
            SizedBox(
              width: 36,
              child: Text(
                '${item.itemQuantity}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Add one',
              icon: const Icon(Icons.add_circle_outline),
              color: cs.primary,
              onPressed: onPlus,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet();

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _qty = TextEditingController();
  final _min = TextEditingController();
  final _price = TextEditingController();
  String _category = InventoryCategory.polish;

  @override
  void dispose() {
    _name.dispose();
    _qty.dispose();
    _min.dispose();
    _price.dispose();
    super.dispose();
  }

  String? _needNumber(String? v) {
    if (v == null || int.tryParse(v.trim()) == null) {
      return 'Enter a whole number';
    }
    if (int.parse(v.trim()) < 0) {
      return 'Cannot be below 0';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      InventoryItemModel(
        itemId: 'inv_${DateTime.now().millisecondsSinceEpoch}',
        itemName: _name.text.trim(),
        itemCategory: _category,
        itemQuantity: int.parse(_qty.text.trim()),
        itemMinThreshold: int.parse(_min.text.trim()),
        itemUnitPrice: double.parse(_price.text.trim()),
        itemUpdatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add supply', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter the item name'
                    : null,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  for (final c in InventoryCategory.values)
                    ChoiceChip(
                      label: Text(c),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qty,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      validator: _needNumber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _min,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Low stock at',
                        border: OutlineInputBorder(),
                      ),
                      validator: _needNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Unit price (RM)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || double.tryParse(v.trim()) == null)
                    ? 'Enter a price'
                    : null,
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
