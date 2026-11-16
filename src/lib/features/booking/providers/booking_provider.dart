
import 'package:flutter/foundation.dart';

import '../../../models/service_model.dart';

class BookingProvider extends ChangeNotifier {
  ServiceModel? _selectedService;

  ServiceModel? get selectedService => _selectedService;

  bool get hasSelectedService => _selectedService != null;

  void selectService(ServiceModel service) {
    _selectedService = service;
    notifyListeners();
  }

  void clearSelectedService() {
    _selectedService = null;
    notifyListeners();
  }
}
