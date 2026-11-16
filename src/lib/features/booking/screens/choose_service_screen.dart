
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_provider.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_service_card.dart';
import '../../availability/screens/date_time_screen.dart';

class ChooseServiceScreen extends StatelessWidget {
  const ChooseServiceScreen({super.key});

  static const Color burgundy = Color(0xFF590019);
  static const Color cream = Color(0xFFF7F2E0);
  static const Color brown = Color(0xFF58372B);

  @override
  Widget build(BuildContext context) {
    final services = context.watch<AppProvider>().services;
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
          Expanded(
            child: services.isEmpty
                ? const Center(
                    child: Text(
                      'No services available.',
                      style: TextStyle(color: brown),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16, 18, 16, 10,
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];

                      final isSelected =
                          bookingProvider.selectedService?.serviceId ==
                              service.serviceId;

                      return BookingServiceCard(
                        service: service,
                        isSelected: isSelected,
                        onSelect: () {
                          bookingProvider.selectService(service);
                        },
                      );
                    },
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
