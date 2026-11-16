// src/lib/models/inventory_item_model.dart
// Firestore collection: inventory   |   Primary key: itemId
// Requirements: FR-07 Inventory, FR-14 Low Stock Alerts (GitHub Issue #19).
// Category values: see enums.dart (InventoryCategory).

import 'model_utils.dart';

class InventoryItemModel {
  final String itemId; // unique supply item identifier
  final String itemName; // e.g. 'Gel Base Coat', 'Nail Tips'
  final String itemCategory; // 'polish' | 'tips' | 'charms' | 'tools'
  final int itemQuantity; // current stock count
  final int itemMinThreshold; // low stock alert trigger level
  final double itemUnitPrice; // purchase cost per unit in MYR
  final DateTime itemUpdatedAt; // last stock update timestamp

  const InventoryItemModel({
    required this.itemId,
    required this.itemName,
    required this.itemCategory,
    required this.itemQuantity,
    required this.itemMinThreshold,
    required this.itemUnitPrice,
    required this.itemUpdatedAt,
  });

  /// FR-14: low stock when the quantity is at or below the minimum level.
  bool get isLowStock => itemQuantity <= itemMinThreshold;

  InventoryItemModel copyWith({int? itemQuantity, DateTime? itemUpdatedAt}) {
    return InventoryItemModel(
      itemId: itemId,
      itemName: itemName,
      itemCategory: itemCategory,
      itemQuantity: itemQuantity ?? this.itemQuantity,
      itemMinThreshold: itemMinThreshold,
      itemUnitPrice: itemUnitPrice,
      itemUpdatedAt: itemUpdatedAt ?? this.itemUpdatedAt,
    );
  }

  factory InventoryItemModel.fromMap(Map<String, dynamic> data) {
    return InventoryItemModel(
      itemId: data['itemId'] ?? '',
      itemName: data['itemName'] ?? '',
      itemCategory: data['itemCategory'] ?? 'polish',
      itemQuantity: (data['itemQuantity'] ?? 0).toInt(),
      itemMinThreshold: (data['itemMinThreshold'] ?? 0).toInt(),
      itemUnitPrice: (data['itemUnitPrice'] ?? 0).toDouble(),
      itemUpdatedAt: toDateTime(data['itemUpdatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'itemCategory': itemCategory,
      'itemQuantity': itemQuantity,
      'itemMinThreshold': itemMinThreshold,
      'itemUnitPrice': itemUnitPrice,
      'itemUpdatedAt': itemUpdatedAt,
    };
  }
}
