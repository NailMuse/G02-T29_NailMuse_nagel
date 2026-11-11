// src/lib/models/service_model.dart
// Firestore collection: services   |   Primary key: serviceId
// Requirement: FR-04 Service Catalogue. Category values: see enums.dart (ServiceCategory).

class ServiceModel {
  final String serviceId; // unique service identifier
  final String serviceName; // e.g. 'Classic Gel Manicure'
  final String serviceDescription; // short text shown to the customer
  final double servicePrice; // price in MYR (starting price)
  final int serviceDurationMins; // estimated duration in minutes
  final String serviceCategory; // 'gel' | 'extensions' | 'care'

  const ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.servicePrice,
    required this.serviceDurationMins,
    required this.serviceCategory,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> data) {
    return ServiceModel(
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      serviceDescription: data['serviceDescription'] ?? '',
      servicePrice: (data['servicePrice'] ?? 0).toDouble(),
      serviceDurationMins: (data['serviceDurationMins'] ?? 0).toInt(),
      serviceCategory: data['serviceCategory'] ?? 'gel',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceDescription': serviceDescription,
      'servicePrice': servicePrice,
      'serviceDurationMins': serviceDurationMins,
      'serviceCategory': serviceCategory,
    };
  }
}
