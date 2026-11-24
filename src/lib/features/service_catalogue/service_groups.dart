// The service groups of the owner's menu.
// Used by BOTH the owner Service Catalogue (UI-11) and the customer
// Choose Service screen (UI-02), so the two screens always match.

import '../../models/service_model.dart';

class ServiceGroups {
  ServiceGroups._();

  /// category -> group title (in menu order)
  static const Map<String, String> titles = {
    'gel': 'Classic Gel Manicure',
    'extensions': 'Classic Gel Extensions',
    'addon': 'Add-ons',
    'removal': 'Removal',
    'henna': 'Henna Manicure',
  };

  static const String other = 'Other Services';

  /// Returns the groups in menu order. Empty groups are left out.
  static Map<String, List<ServiceModel>> group(List<ServiceModel> services) {
    final groups = <String, List<ServiceModel>>{
      for (final title in titles.values) title: [],
      other: [],
    };

    for (final service in services) {
      final title = titles[service.serviceCategory] ?? other;
      groups[title]!.add(service);
    }

    groups.removeWhere((_, list) => list.isEmpty);
    return groups;
  }
}
