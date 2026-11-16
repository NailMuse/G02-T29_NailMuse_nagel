
class AppointmentModel {
  final String appointmentId;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final DateTime appointmentDateTime;
  final String appointmentStatus;

  // Selected service
  final String? serviceId;
  final String? serviceName;
  final double? servicePrice;

  // Design preferences
  final String? designStyle;
  final String? designColour;
  final String? designReferenceUrl;
  final String? designNotes;

  final bool depositPaid;
  final bool reminderSent;
  final DateTime appointmentCreatedAt;

  AppointmentModel({
    required this.appointmentId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.appointmentDateTime,
    required this.appointmentStatus,
    this.serviceId,
    this.serviceName,
    this.servicePrice,
    this.designStyle,
    this.designColour,
    this.designReferenceUrl,
    this.designNotes,
    required this.depositPaid,
    required this.reminderSent,
    required this.appointmentCreatedAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> data) {
    return AppointmentModel(
      appointmentId: data['appointmentId'] ?? '',
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      appointmentDateTime: DateTime.parse(
        data['appointmentDateTime'].toString(),
      ),
      appointmentStatus: data['appointmentStatus'] ?? 'pending',
      serviceId: data['serviceId'],
      serviceName: data['serviceName'],
      servicePrice: (data['servicePrice'] as num?)?.toDouble(),
      designStyle: data['designStyle'],
      designColour: data['designColour'],
      designReferenceUrl: data['designReferenceUrl'],
      designNotes: data['designNotes'],
      depositPaid: data['depositPaid'] ?? false,
      reminderSent: data['reminderSent'] ?? false,
      appointmentCreatedAt: DateTime.parse(
        data['appointmentCreatedAt'].toString(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'appointmentDateTime': appointmentDateTime.toIso8601String(),
      'appointmentStatus': appointmentStatus,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'servicePrice': servicePrice,
      'designStyle': designStyle,
      'designColour': designColour,
      'designReferenceUrl': designReferenceUrl,
      'designNotes': designNotes,
      'depositPaid': depositPaid,
      'reminderSent': reminderSent,
      'appointmentCreatedAt': appointmentCreatedAt.toIso8601String(),
    };
  }
}
