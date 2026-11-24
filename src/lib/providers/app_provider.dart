
import 'package:flutter/foundation.dart';

import '../models/appointment_model.dart';
import '../models/service_model.dart';
import '../models/inventory_item_model.dart';
import '../data/mock_data.dart';

class AppProvider with ChangeNotifier {
  final List<ServiceModel> _services = MockData.services;

  final List<AppointmentModel> _appointments = [];

  final List<InventoryItemModel> _inventory =
      MockData.inventoryItems;

  List<ServiceModel> get services => _services;

  List<AppointmentModel> get appointments => _appointments;

  List<InventoryItemModel> get inventory => _inventory;

  // FR-07 Inventory (Issue #19) - added by Aida
  void addInventoryItem(InventoryItemModel item) {
    _inventory.insert(0, item);
    notifyListeners();
  }

  void updateInventoryQuantity(String itemId, int newQuantity) {
    final index = _inventory.indexWhere((x) => x.itemId == itemId);
    if (index == -1 || newQuantity < 0) return; // stock cannot be below 0
    _inventory[index] = _inventory[index].copyWith(
      itemQuantity: newQuantity,
      itemUpdatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  // Service management
  void addService(ServiceModel service) {
    _services.add(service);
    notifyListeners();
  }

  void updateService(ServiceModel updatedService) {
    final index = _services.indexWhere(
      (service) => service.serviceId == updatedService.serviceId,
    );

    if (index == -1) return;

    _services[index] = updatedService;
    notifyListeners();
  }

  void removeService(String serviceId) {
    _services.removeWhere(
      (service) => service.serviceId == serviceId,
    );

    notifyListeners();
  }

  // Appointment management
  void addAppointment(AppointmentModel appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void removeAppointment(String appointmentId) {
    _appointments.removeWhere(
      (appt) => appt.appointmentId == appointmentId,
    );

    notifyListeners();
  }

  void updateAppointmentStatus(
    String appointmentId,
    String status,
  ) {
    final index = _appointments.indexWhere(
      (appt) => appt.appointmentId == appointmentId,
    );

    if (index == -1) return;

    final appointment = _appointments[index];

    _appointments[index] = AppointmentModel(
      appointmentId: appointment.appointmentId,
      customerId: appointment.customerId,
      customerName: appointment.customerName,
      customerPhone: appointment.customerPhone,
      appointmentDateTime: appointment.appointmentDateTime,
      appointmentStatus: status,
      serviceId: appointment.serviceId,
      serviceName: appointment.serviceName,
      servicePrice: appointment.servicePrice,
      designStyle: appointment.designStyle,
      designColour: appointment.designColour,
      designReferenceUrl: appointment.designReferenceUrl,
      designNotes: appointment.designNotes,
      depositPaid: appointment.depositPaid,
      reminderSent: appointment.reminderSent,
      appointmentCreatedAt: appointment.appointmentCreatedAt,
    );

    notifyListeners();
  }

  // FR-11: the owner marks that the deposit was received.
  void markDepositPaid(String appointmentId) {
    final index = _appointments.indexWhere(
      (appt) => appt.appointmentId == appointmentId,
    );

    if (index == -1) return;

    final appointment = _appointments[index];

    _appointments[index] = AppointmentModel(
      appointmentId: appointment.appointmentId,
      customerId: appointment.customerId,
      customerName: appointment.customerName,
      customerPhone: appointment.customerPhone,
      appointmentDateTime: appointment.appointmentDateTime,
      appointmentStatus: appointment.appointmentStatus,
      serviceId: appointment.serviceId,
      serviceName: appointment.serviceName,
      servicePrice: appointment.servicePrice,
      designStyle: appointment.designStyle,
      designColour: appointment.designColour,
      designReferenceUrl: appointment.designReferenceUrl,
      designNotes: appointment.designNotes,
      depositPaid: true,
      reminderSent: appointment.reminderSent,
      appointmentCreatedAt: appointment.appointmentCreatedAt,
    );

    notifyListeners();
  }

  // FR-03: the customer moves a booking to a new date and time.
  // The booking goes back to Pending so the owner can confirm again.
  void rescheduleAppointment(String appointmentId, DateTime newDateTime) {
    final index = _appointments.indexWhere(
      (appt) => appt.appointmentId == appointmentId,
    );

    if (index == -1) return;

    final appointment = _appointments[index];

    _appointments[index] = AppointmentModel(
      appointmentId: appointment.appointmentId,
      customerId: appointment.customerId,
      customerName: appointment.customerName,
      customerPhone: appointment.customerPhone,
      appointmentDateTime: newDateTime,
      appointmentStatus: 'Pending',
      serviceId: appointment.serviceId,
      serviceName: appointment.serviceName,
      servicePrice: appointment.servicePrice,
      designStyle: appointment.designStyle,
      designColour: appointment.designColour,
      designReferenceUrl: appointment.designReferenceUrl,
      designNotes: appointment.designNotes,
      depositPaid: appointment.depositPaid,
      reminderSent: appointment.reminderSent,
      appointmentCreatedAt: appointment.appointmentCreatedAt,
    );

    notifyListeners();
  }

  // FR-12: private notes of the owner for each appointment.
  final Map<String, String> _ownerNotes = {};

  String ownerNoteFor(String appointmentId) =>
      _ownerNotes[appointmentId] ?? '';

  void setOwnerNote(String appointmentId, String note) {
    final text = note.trim();
    if (text.isEmpty) {
      _ownerNotes.remove(appointmentId);
    } else {
      _ownerNotes[appointmentId] = text;
    }
    notifyListeners();
  }

  // FR-11: name of the deposit receipt the customer attached.
  final Map<String, String> _receipts = {};

  String receiptFor(String appointmentId) => _receipts[appointmentId] ?? '';

  void setReceipt(String appointmentId, String fileName) {
    _receipts[appointmentId] = fileName;
    notifyListeners();
  }

  // Time slots already booked on one date (for example '7:00 pm').
  // Cancelled and rejected bookings free the slot again.
  Set<String> bookedSlotLabels(DateTime date) {
    final labels = <String>{};

    for (final appt in _appointments) {
      final status = appt.appointmentStatus.toLowerCase();
      if (status == 'cancelled' || status == 'rejected') continue;

      final d = appt.appointmentDateTime;
      if (d.year != date.year || d.month != date.month || d.day != date.day) {
        continue;
      }

      final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final minute = d.minute.toString().padLeft(2, '0');
      final period = d.hour >= 12 ? 'pm' : 'am';
      labels.add('$hour12:$minute $period');
    }

    return labels;
  }
}
