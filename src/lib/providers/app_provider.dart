// lib/providers/app_provider.dart
// Written by Annabell. Changed by Aida (marked "Aida" below) so it works with the approved model classes:
//  1. Inventory methods added for FR-07 (Issue #19).
//  2. updateAppointmentStatus now uses copyWith (the model uses userId/userName/userPhone/serviceId now).
//  3. The lists are copies (List.of) so adding items never fails, even if mock_data uses a fixed list.

import 'package:flutter/foundation.dart';

import '../models/appointment_model.dart';
import '../models/service_model.dart';
import '../models/inventory_item_model.dart';
import '../data/mock_data.dart';

class AppProvider with ChangeNotifier {
  final List<ServiceModel> _services = List.of(MockData.services); // Aida: List.of

  final List<AppointmentModel> _appointments = [];

  final List<InventoryItemModel> _inventory =
      List.of(MockData.inventoryItems); // Aida: List.of

  List<ServiceModel> get services => _services;

  List<AppointmentModel> get appointments => _appointments;

  List<InventoryItemModel> get inventory => _inventory;

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

  // Aida: now uses copyWith, so no field names are repeated here.
  void updateAppointmentStatus(
    String appointmentId,
    String status,
  ) {
    final index = _appointments.indexWhere(
      (appt) => appt.appointmentId == appointmentId,
    );

    if (index != -1) {
      _appointments[index] =
          _appointments[index].copyWith(appointmentStatus: status);
      notifyListeners();
    }
  }

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
}
