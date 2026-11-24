
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_provider.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_service_card.dart';
import '../../availability/screens/date_time_screen.dart';
import '../../service_catalogue/service_groups.dart';
import '../../service_catalogue/widgets/service_category_filter.dart';

class ChooseServiceScreen extends StatefulWidget {
  const ChooseServiceScreen({super.key});

  @override
  State<ChooseServiceScreen> createState() => _ChooseServiceScreenState();
}

class _ChooseServiceScreenState extends State<ChooseServiceScreen> {
  // 'all' or a category such as 'gel' (same buttons as the owner screen)
  String _category = 'all';

  static const Color burgundy = Color(0xFF590019);
  static const Color cream = Color(0xFFF7F2E0);
  static const Color brown = Color(0xFF58372B);

  @override
  Widget build(BuildContext context) {
    final allServices = context.watch<AppProvider>().services;
    final services = _category == 'all'
        ? allServices
        : allServices
            .where((s) => s.serviceCategory == _category)
            .toList();
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: burgundy,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Choose Service',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),
          ServiceCategoryFilter(
            selected: _category,
            onSelected: (value) => setState(() => _category = value),
          ),
          Expanded(
            child: services.isEmpty
                ? const Center(
                    child: Text(
                      'No services available.',
                      style: TextStyle(color: brown),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      16, 8, 16, 10,
                    ),
                    children: [
                      // Same groups as the owner Service Catalogue.
                      for (final entry
                          in ServiceGroups.group(services).entries) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 10),
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: burgundy,
                            ),
                          ),
                        ),
                        for (final service in entry.value)
                          BookingServiceCard(
                            service: service,
                            isSelected: bookingProvider
                                    .selectedService?.serviceId ==
                                service.serviceId,
                            onSelect: () {
                              bookingProvider.selectService(service);
                            },
                          ),
                      ],
                    ],
                  ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              16, 8, 16, 18,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: burgundy,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      burgundy.withValues(alpha: 0.35),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                onPressed: bookingProvider.hasSelectedService
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DateTimeScreen(),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  'Next: Choose Date',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
