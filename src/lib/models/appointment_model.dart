// lib/models/appointment_model.dart

class AppointmentModel {
  final String appointmentId;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final DateTime appointmentDateTime;
  final String appointmentStatus;
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
      appointmentDateTime: data['appointmentDateTime'],
      appointmentStatus: data['appointmentStatus'] ?? 'pending',
      designReferenceUrl: data['designReferenceUrl'],
      designNotes: data['designNotes'],
      depositPaid: data['depositPaid'] ?? false,
      reminderSent: data['reminderSent'] ?? false,
      appointmentCreatedAt: data['appointmentCreatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'appointmentDateTime': appointmentDateTime,
      'appointmentStatus': appointmentStatus,
      'designReferenceUrl': designReferenceUrl,
      'designNotes': designNotes,
      'depositPaid': depositPaid,
      'reminderSent': reminderSent,
      'appointmentCreatedAt': appointmentCreatedAt,
    };
  }
}