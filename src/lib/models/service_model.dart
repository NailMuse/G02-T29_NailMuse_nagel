
class ServiceModel {
  final String serviceId;
  final String serviceName;
  final String serviceDescription;
  final double servicePrice;
  final int serviceDurationMins;
  final String serviceCategory;

  const ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.servicePrice,
    required this.serviceDurationMins,
    required this.serviceCategory,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      serviceId: map['serviceId'] as String,
      serviceName: map['serviceName'] as String,
      serviceDescription: map['serviceDescription'] as String,
      servicePrice: (map['servicePrice'] as num).toDouble(),
      serviceDurationMins: map['serviceDurationMins'] as int,
      serviceCategory: map['serviceCategory'] as String,
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
