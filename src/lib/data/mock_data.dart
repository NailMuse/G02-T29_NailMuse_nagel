
import '../models/service_model.dart';
import '../models/inventory_item_model.dart';

class MockData {
  static List<ServiceModel> services = [
    const ServiceModel(
      serviceId: 'SRV-001',
      serviceName: 'Classic Gel',
      serviceDescription: 'Simple and elegant gel manicure.',
      servicePrice: 58.0,
      serviceDurationMins: 60,
      serviceCategory: 'gel',
    ),
    const ServiceModel(
      serviceId: 'SRV-002',
      serviceName: 'Classic Gel (Design)',
      serviceDescription: 'Gel manicure with customised nail art.',
      servicePrice: 68.0,
      serviceDurationMins: 75,
      serviceCategory: 'gel',
    ),
    const ServiceModel(
      serviceId: 'SRV-003',
      serviceName: 'Builder Gel',
      serviceDescription: 'Strengthening gel for natural nails.',
      servicePrice: 78.0,
      serviceDurationMins: 90,
      serviceCategory: 'gel',
    ),
    const ServiceModel(
      serviceId: 'SRV-004',
      serviceName: 'Nail Extensions',
      serviceDescription: 'Beautiful extensions with customised shape.',
      servicePrice: 98.0,
      serviceDurationMins: 120,
      serviceCategory: 'extensions',
    ),
    const ServiceModel(
      serviceId: 'SRV-005',
      serviceName: 'Express Manicure',
      serviceDescription: 'Quick manicure for everyday nail care.',
      servicePrice: 38.0,
      serviceDurationMins: 30,
      serviceCategory: 'care',
    ),
    const ServiceModel(
      serviceId: 'SRV-006',
      serviceName: 'Nail Spa Treatment',
      serviceDescription: 'Relaxing nail care and conditioning treatment.',
      servicePrice: 48.0,
      serviceDurationMins: 45,
      serviceCategory: 'care',
    ),
  ];

  static List<InventoryItemModel> inventoryItems = [];
}
