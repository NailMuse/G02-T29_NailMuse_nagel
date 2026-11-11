// src/lib/models/availability_slot_model.dart
// Firestore collection: availability_slots   |   Primary key: slotId
// Requirement: FR-02 Availability Calendar.

class AvailabilitySlotModel {
  final String slotId; // unique slot identifier
  final String slotDate; // 'YYYY-MM-DD'
  final String slotStartTime; // 'HH:MM' (24-hour), e.g. '19:00'
  final String slotEndTime; // 'HH:MM' (24-hour), e.g. '21:00'
  final bool isBooked; // true if reserved by an appointment
  final bool blockedByOwner; // true if the owner closed the slot (rest/break)

  const AvailabilitySlotModel({
    required this.slotId,
    required this.slotDate,
    required this.slotStartTime,
    required this.slotEndTime,
    this.isBooked = false,
    this.blockedByOwner = false,
  });

  /// Customers only see slots that are open.
  bool get isAvailable => !isBooked && !blockedByOwner;

  AvailabilitySlotModel copyWith({bool? isBooked, bool? blockedByOwner}) {
    return AvailabilitySlotModel(
      slotId: slotId,
      slotDate: slotDate,
      slotStartTime: slotStartTime,
      slotEndTime: slotEndTime,
      isBooked: isBooked ?? this.isBooked,
      blockedByOwner: blockedByOwner ?? this.blockedByOwner,
    );
  }

  factory AvailabilitySlotModel.fromMap(Map<String, dynamic> data) {
    return AvailabilitySlotModel(
      slotId: data['slotId'] ?? '',
      slotDate: data['slotDate'] ?? '',
      slotStartTime: data['slotStartTime'] ?? '',
      slotEndTime: data['slotEndTime'] ?? '',
      isBooked: data['isBooked'] ?? false,
      blockedByOwner: data['blockedByOwner'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'slotId': slotId,
      'slotDate': slotDate,
      'slotStartTime': slotStartTime,
      'slotEndTime': slotEndTime,
      'isBooked': isBooked,
      'blockedByOwner': blockedByOwner,
    };
  }
}
