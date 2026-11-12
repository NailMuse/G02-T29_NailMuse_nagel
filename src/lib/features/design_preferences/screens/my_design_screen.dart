
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/appointment_model.dart';
import '../../../providers/app_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../../availability/providers/availability_provider.dart';
import '../providers/design_preferences_provider.dart';
import '../widgets/design_option_card.dart';

class MyDesignScreen extends StatefulWidget {
  const MyDesignScreen({super.key});

  @override
  State<MyDesignScreen> createState() => _MyDesignScreenState();
}

class _MyDesignScreenState extends State<MyDesignScreen> {
  static const Color burgundy = Color(0xFF590019);
  static const Color cream = Color(0xFFF7F2E0);
  static const Color brown = Color(0xFF58372B);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _notesController = TextEditingController();
  final _imageController = TextEditingController();

  bool _submitting = false;

  @override
  void initState() {
    super.initState();

    // Restore previously entered design preferences.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider = context.read<DesignPreferencesProvider>();

      _notesController.text = provider.designNotes;
      _imageController.text = provider.referenceImageUrl;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  DateTime _combineDateAndTime(
    DateTime date,
    String time,
  ) {
    final parts = time.trim().split(' ');
    final timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final period = parts.length > 1
        ? parts[1].toLowerCase()
        : '';

    if (period == 'pm' && hour != 12) {
      hour += 12;
    } else if (period == 'am' && hour == 12) {
      hour = 0;
    }

    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    final booking = context.read<BookingProvider>();
    final availability = context.read<AvailabilityProvider>();
    final design = context.read<DesignPreferencesProvider>();
    final app = context.read<AppProvider>();

    final service = booking.selectedService;
    final date = availability.selectedDate;
    final time = availability.selectedTime;

    if (service == null || date == null || time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a service, appointment date and time.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      final appointment = AppointmentModel(
        appointmentId:
            'APT-${DateTime.now().millisecondsSinceEpoch}',
        customerId: 'CUSTOMER-001',
        customerName: _nameController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        appointmentDateTime: _combineDateAndTime(date, time),
        appointmentStatus: 'pending',
        serviceId: service.serviceId,
        serviceName: service.serviceName,
        servicePrice: service.servicePrice,
        designStyle: design.selectedStyle,
        designColour: design.selectedColour,
        designReferenceUrl:
            design.referenceImageUrl.isEmpty
                ? null
                : design.referenceImageUrl,
        designNotes: design.designNotes.isEmpty
            ? null
            : design.designNotes,
        depositPaid: false,
        reminderSent: false,
        appointmentCreatedAt: DateTime.now(),
      );

      app.addAppointment(appointment);

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Booking Submitted!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your appointment has been submitted successfully.',
                ),
                const SizedBox(height: 16),
                Text('Service: ${service.serviceName}'),
                Text('Price: RM ${service.servicePrice.toStringAsFixed(2)}'),
                Text('Date: ${date.day}/${date.month}/${date.year}'),
                Text('Time: $time'),
                const SizedBox(height: 10),
                const Text(
                  'Status: Pending',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.popUntil(context, (route) => route.isFirst);
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
    final provider = context.watch<DesignPreferencesProvider>();

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: burgundy,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'My Design',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Your Nail Style',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: brown,
                ),
              ),
              const SizedBox(height: 12),

              ...provider.styles.map(
                (style) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DesignOptionCard(
                    title: style,
                    isSelected: provider.selectedStyle == style,
                    onTap: () => provider.selectStyle(style),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Preferred Colour',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: brown,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: provider.colours.map((colour) {
                  return ChoiceChip(
                    label: Text(colour),
                    selected: provider.selectedColour == colour,
                    selectedColor: const Color(0xFF80AEE8),
                    onSelected: (_) => provider.selectColour(colour),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              const Text(
                'Design Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: brown,
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: _inputDecoration(
                  'Describe your preferred nail design...',
                ),
                onChanged: provider.updateNotes,
              ),

              const SizedBox(height: 24),

              const Text(
                'Reference Image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: brown,
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _imageController,
                decoration: _inputDecoration(
                  'Paste reference image URL',
                  icon: Icons.image_outlined,
                ),
                onChanged: provider.updateReferenceImageUrl,
              ),

              if (provider.referenceImageUrl.isNotEmpty) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    provider.referenceImageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Text(
                      'Unable to load reference image.',
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 28),

              const Text(
                'Customer Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: brown,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Full Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('Phone Number'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number.';
                  }

                  if (value.trim().length < 8) {
                    return 'Please enter a valid phone number.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: burgundy,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: _submitting ? null : _submitBooking,
                  child: _submitting
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Submit Booking',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint, {
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
