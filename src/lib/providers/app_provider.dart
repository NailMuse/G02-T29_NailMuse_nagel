
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
}
