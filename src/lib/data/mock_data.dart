
import '../models/service_model.dart';
import '../models/inventory_item_model.dart';

class MockData {
  // Service menu from the client (Ms. Michelle). Prices in RM.
  static List<ServiceModel> services = [
    const ServiceModel(
      serviceId: 'SRV-001',
      serviceName: 'Classic gel manicure, plain',
      serviceDescription: 'Simple and elegant gel manicure.',
      servicePrice: 58.0,
      serviceDurationMins: 60,
      serviceCategory: 'gel',
    ),
    const ServiceModel(
      serviceId: 'SRV-002',
      serviceName: 'Cat-eye or glazed',
      serviceDescription: 'Gel manicure with a cat-eye or glazed finish.',
      servicePrice: 68.0,
      serviceDurationMins: 75,
      serviceCategory: 'gel',
    ),
    const ServiceModel(
      serviceId: 'SRV-003',
      serviceName: 'Classic gel extensions, plain',
      serviceDescription: 'Gel extensions with a plain finish.',
      servicePrice: 78.0,
      serviceDurationMins: 120,
      serviceCategory: 'extensions',
    ),
    const ServiceModel(
      serviceId: 'SRV-004',
      serviceName: 'Builder gel / overlay (add-on)',
      serviceDescription: 'Extra strength for natural nails. Add to a manicure.',
      servicePrice: 20.0,
      serviceDurationMins: 30,
      serviceCategory: 'addon',
    ),
    const ServiceModel(
      serviceId: 'SRV-005',
      serviceName: 'Gel removal, in-house',
      serviceDescription: 'Removal of gel done at nägel.',
      servicePrice: 10.0,
      serviceDurationMins: 20,
      serviceCategory: 'removal',
    ),
    const ServiceModel(
      serviceId: 'SRV-006',
      serviceName: 'Gel removal, foreign',
      serviceDescription: 'Removal of gel done at another salon.',
      servicePrice: 20.0,
      serviceDurationMins: 30,
      serviceCategory: 'removal',
    ),
    const ServiceModel(
      serviceId: 'SRV-007',
      serviceName: 'Extensions removal, in-house',
      serviceDescription: 'Removal of extensions done at nägel.',
      servicePrice: 20.0,
      serviceDurationMins: 30,
      serviceCategory: 'removal',
    ),
    const ServiceModel(
      serviceId: 'SRV-008',
      serviceName: 'Extensions removal, foreign',
      serviceDescription: 'Removal of extensions done at another salon.',
      servicePrice: 30.0,
      serviceDurationMins: 40,
      serviceCategory: 'removal',
    ),
    const ServiceModel(
      serviceId: 'SRV-009',
      serviceName: 'Henna express',
      serviceDescription: 'Quick henna manicure.',
      servicePrice: 48.0,
      serviceDurationMins: 45,
      serviceCategory: 'henna',
    ),
  ];

  // Demo stock for the owner Inventory screen (UI-10). Not real prices.
  static List<InventoryItemModel> inventoryItems = [
    InventoryItemModel(
      itemId: 'INV-001',
      itemName: 'Gel base coat',
      itemCategory: 'polish',
      itemQuantity: 2,
      itemMinThreshold: 3,
      itemUnitPrice: 18.0,
      itemUpdatedAt: DateTime(2026, 11, 16),
    ),
    InventoryItemModel(
      itemId: 'INV-002',
      itemName: 'Gel top coat',
      itemCategory: 'polish',
      itemQuantity: 6,
      itemMinThreshold: 3,
      itemUnitPrice: 18.0,
      itemUpdatedAt: DateTime(2026, 11, 16),
    ),
    InventoryItemModel(
      itemId: 'INV-003',
      itemName: 'Gel colours',
      itemCategory: 'polish',
      itemQuantity: 24,
      itemMinThreshold: 5,
      itemUnitPrice: 12.0,
      itemUpdatedAt: DateTime(2026, 11, 16),
    ),
    InventoryItemModel(
      itemId: 'INV-004',
      itemName: 'Cuticle oil',
      itemCategory: 'tools',
      itemQuantity: 5,
      itemMinThreshold: 2,
      itemUnitPrice: 8.0,
      itemUpdatedAt: DateTime(2026, 11, 16),
    ),
    InventoryItemModel(
      itemId: 'INV-005',
      itemName: 'Cotton pads',
      itemCategory: 'tools',
      itemQuantity: 12,
      itemMinThreshold: 4,
      itemUnitPrice: 6.0,
      itemUpdatedAt: DateTime(2026, 11, 16),
    ),
  ];
}
