import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/appointment_model.dart';
import '../../../providers/app_provider.dart';
import '../../../screens/my_slot_screen.dart';
import '../../availability/providers/availability_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../../design_preferences/providers/design_preferences_provider.dart';
import '../../../screens/customer_dashboard_screen.dart';

class ConfirmDepositScreen extends StatefulWidget {
  const ConfirmDepositScreen({super.key});

  @override
  State<ConfirmDepositScreen> createState() =>
      _ConfirmDepositScreenState();
}

class _ConfirmDepositScreenState
    extends State<ConfirmDepositScreen> {
  static const Color burgundy =
      Color(0xFF590019);

  static const Color cream =
      Color(0xFFF7F2E0);

  final _formKey =
      GlobalKey<FormState>();

  final _nameController =
      TextEditingController();

  final _phoneController =
      TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  DateTime _combineDateAndTime(
    DateTime date,
    String time,
  ) {
    final parts = time.trim().split(' ');
    final timeParts = parts[0].split(':');

    int hour =
        int.parse(timeParts[0]);

    final minute =
        int.parse(timeParts[1]);

    if (parts.length > 1) {
      final period =
          parts[1].toLowerCase();

      if (period == 'pm' &&
          hour != 12) {
        hour += 12;
      }

      if (period == 'am' &&
          hour == 12) {
        hour = 0;
      }
    }

    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  Future<void> _confirmBooking() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final booking =
        context.read<BookingProvider>();

    final availability =
        context.read<
            AvailabilityProvider>();

    final design =
        context.read<
            DesignPreferencesProvider>();

    final app =
        context.read<AppProvider>();

    final service =
        booking.selectedService;

    final date =
        availability.selectedDate;

    final time =
        availability.selectedTime;

    if (service == null ||
        date == null ||
        time == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Missing appointment information.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      final appointment =
          AppointmentModel(
        appointmentId:
            'APT-${DateTime.now().millisecondsSinceEpoch}',

        customerId:
            'CUSTOMER-001',

        customerName:
            _nameController.text.trim(),

        customerPhone:
            _phoneController.text.trim(),

        appointmentDateTime:
            _combineDateAndTime(
          date,
          time,
        ),

        appointmentStatus:
            'Pending',

        serviceId:
            service.serviceId,

        serviceName:
            service.serviceName,

        servicePrice:
            service.servicePrice,

        designStyle:
            design.selectedStyle,

        designColour:
            design.selectedColour,

        designReferenceUrl:
            design
                    .referenceImageUrl
                    .isEmpty
                ? null
                : design
                    .referenceImageUrl,

        designNotes:
            design.designNotes
                    .isEmpty
                ? null
                : design.designNotes,

        depositPaid: false,
        reminderSent: false,

        appointmentCreatedAt:
            DateTime.now(),
      );

      app.addAppointment(
        appointment,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
          title: const Text(
            'Booking Submitted',
          ),
          content: const Text(
            'Your appointment has been booked successfully.\n\n'
            'Status: Pending Confirmation',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const MySlotScreen(),
                  ),
                  (_) => false,
                );
              },
              child:
                  const Text(
                'OK',
              ),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        context.watch<BookingProvider>();

    final availability =
        context.watch<
            AvailabilityProvider>();

    final service =
        booking.selectedService;

    if (service == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No service selected.',
          ),
        ),
      );
    }

    final deposit =
        service.servicePrice * 0.20;

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(automaticallyImplyLeading: false,
        backgroundColor: burgundy,
        foregroundColor:
            Colors.white,
            centerTitle: true,
        title: const Text(
          'Confirm',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Services'),
                        Text(service.serviceName),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Date'),
                        Text(
                          '${availability.selectedDate?.day}/${availability.selectedDate?.month}/${availability.selectedDate?.year}',
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Time'),
                        Text(
                          availability.selectedTime ?? '',
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price'),
                        Text(
                          'RM ${service.servicePrice.toStringAsFixed(0)}',
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Divider(),
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Deposit (20%)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'RM ${deposit.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF80AEE8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      color: Colors.white,
                    ),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Text(
                        'Pay deposit by\n'
                        'QR or Bank Transfer\n'
                        'upload receipt here',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              TextFormField(
                controller:
                    _nameController,
                decoration:
                    InputDecoration(
                  hintText: 'Full Name',
                  border: const UnderlineInputBorder(),
                ),
                validator:
                    (value) {
                  if (value ==
                          null ||
                      value
                          .trim()
                          .isEmpty) {
                    return 'Please enter your name';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 16,
              ),

              TextFormField(
                controller:
                    _phoneController,
                keyboardType:
                    TextInputType
                        .phone,
                decoration:
                    InputDecoration(
                  hintText: 'WhatsApp Number',
                  border: const UnderlineInputBorder(),
                ),
                validator:
                    (value) {
                  if (value ==
                          null ||
                      value
                          .trim()
                          .isEmpty) {
                    return 'Please enter your phone number';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 24,
              ),

              const Text(
                'Deposit Receipt',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: burgundy,
                  minimumSize:
                      const Size(double.infinity, 50),
                  shape: const StadiumBorder(),
                  side: const BorderSide(
                    color: burgundy,
                    width: 1.5
                  ),
                ).copyWith(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.white,
                  ),
                ),
                child: const Text(
                  'Upload receipt',
                  style: TextStyle(
                    color: burgundy,
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              SizedBox(
                width:
                    double.infinity,
                height: 50,
                child:
                    ElevatedButton(
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        burgundy,
                    foregroundColor:
                        Colors.white,
                  ),
                  onPressed:
                      _submitting
                          ? null
                          : _confirmBooking,
                  child: _submitting
                      ? const CircularProgressIndicator(
                          color: Colors
                              .white,
                        )
                      : const Text(
                          'Confirm Booking',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCE8F8),
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CustomerDashboardScreen(),
                ),
                (_) => false,
              );
              break;

            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const MySlotScreen(),
                ),
                (_) => false,
              );
              break;

            case 2:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const NailMuseAiPlaceholder(),
                ),
                (_) => false,
              );
            break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Book Now',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'My Slot',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Nail Muse AI',
          ),
        ],
      ),
    );
  }
}