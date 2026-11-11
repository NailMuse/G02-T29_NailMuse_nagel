
import 'package:flutter/material.dart';

import '../../../models/service_model.dart';
import '../../../providers/app_provider.dart';

class CatalogueProvider extends ChangeNotifier {
  final AppProvider appProvider;

  CatalogueProvider(this.appProvider);

  String _selectedCategory = 'all';

  String get selectedCategory => _selectedCategory;

  List<ServiceModel> get services => appProvider.services;

  List<ServiceModel> get filteredServices {
    if (_selectedCategory == 'all') {
      return services;
    }

    return services
        .where(
          (service) => service.serviceCategory == _selectedCategory,
        )
        .toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addService(ServiceModel service) {
    appProvider.addService(service);
    notifyListeners();
  }

  void updateService(ServiceModel updatedService) {
    appProvider.updateService(updatedService);
    notifyListeners();
  }

  void removeService(String serviceId) {
    appProvider.removeService(serviceId);
    notifyListeners();
  }
}
