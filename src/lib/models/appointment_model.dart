// src/lib/models/appointment_model.dart
// Firestore collection: appointments   |   Primary key: appointmentId
// Requirements: FR-01, FR-03, FR-05, FR-06. Status values: see enums.dart (AppointmentStatus).
//
// NOTE for the team: the first draft of this file used customerId / customerName / customerPhone.
// The approved schema (class.pdf) uses userId / userName / userPhone and also has serviceId.
// This version follows the approved schema.

import 'enums.dart';
import 'model_utils.dart';

class AppointmentModel {
  final String appointmentId; // unique booking identifier
  final String userId; // reference to users.userId
  final String userName; // denormalized customer name (fast reads)
  final String userPhone; // customer phone
  final String serviceId; // reference to services.serviceId
  final String appointmentName; // service name shown in lists (for example 'Classic Gel Manicure')
  final DateTime appointmentDateTime; // scheduled date and time
  final String appointmentStatus; // 'pending' | 'confirmed' | 'completed' | 'cancelled'
  final String? designReferenceUrl; // storage URL of the design photo (FR-05)
  final String? designNotes; // style / shape / colour / occasion (FR-05)
  final bool depositPaid; // deposit status flag
  final bool reminderSent; // automated notification status (FR-06)
  final DateTime appointmentCreatedAt; // booking creation timestamp

  const AppointmentModel({
    required this.appointmentId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.serviceId,
    required this.appointmentName,
    required this.appointmentDateTime,
    this.appointmentStatus = AppointmentStatus.pending,
    this.designReferenceUrl,
    this.designNotes,
    this.depositPaid = false,
    this.reminderSent = false,
    required this.appointmentCreatedAt,
  });

  /// 48-hour policy: free cancel or reschedule only if at least 48 hours are left.
  bool canCancelFree({DateTime? now}) =>
      appointmentDateTime.difference(now ?? DateTime.now()).inHours >= 48;

  AppointmentModel copyWith({
    String? appointmentStatus,
    DateTime? appointmentDateTime,
    bool? depositPaid,
    bool? reminderSent,
    String? designReferenceUrl,
    String? designNotes,
  }) {
    return AppointmentModel(
      appointmentId: appointmentId,
      userId: userId,
      userName: userName,
      userPhone: userPhone,
      serviceId: serviceId,
      appointmentName: appointmentName,
      appointmentDateTime: appointmentDateTime ?? this.appointmentDateTime,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      designReferenceUrl: designReferenceUrl ?? this.designReferenceUrl,
      designNotes: designNotes ?? this.designNotes,
      depositPaid: depositPaid ?? this.depositPaid,
      reminderSent: reminderSent ?? this.reminderSent,
      appointmentCreatedAt: appointmentCreatedAt,
    );
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> data) {
    return AppointmentModel(
      appointmentId: data['appointmentId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      serviceId: data['serviceId'] ?? '',
      appointmentName: data['appointmentName'] ?? '',
      appointmentDateTime: toDateTime(data['appointmentDateTime']),
      appointmentStatus: data['appointmentStatus'] ?? AppointmentStatus.pending,
      designReferenceUrl: data['designReferenceUrl'],
      designNotes: data['designNotes'],
      depositPaid: data['depositPaid'] ?? false,
      reminderSent: data['reminderSent'] ?? false,
      appointmentCreatedAt: toDateTime(data['appointmentCreatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'serviceId': serviceId,
      'appointmentName': appointmentName,
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
