// lib/screens/my_slot_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/services/auth_service.dart';
import '../features/availability/providers/availability_provider.dart';
import '../models/appointment_model.dart';
import '../models/enums.dart';
import '../providers/app_provider.dart';
import 'customer_dashboard_screen.dart';

class MySlotScreen extends StatelessWidget {
  const MySlotScreen({super.key});

  // Change the date and time of a booking (FR-03).
  // Only allowed at least 48 hours before the appointment.
  Future<void> _askReschedule(
    BuildContext context,
    AppointmentModel appt,
  ) async {
    final hoursLeft =
        appt.appointmentDateTime.difference(DateTime.now()).inHours;

    if (hoursLeft < 48) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Reschedule Policy'),
          content: const Text(
            'Rescheduling or cancellation must be done at least 48 hours '
            'before the appointment.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final availability = context.read<AvailabilityProvider>();
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      helpText: 'Choose a new date',
      selectableDayPredicate: (day) {
        if (!availability.isDateOpen(day)) return false;
        final booked = context.read<AppProvider>().bookedSlotLabels(day);
        return !AvailabilityProvider.slotsFor(day)
            .every((slot) => booked.contains(slot));
      },
    );

    if (date == null || !context.mounted) return;

    final booked = context.read<AppProvider>().bookedSlotLabels(date);
    final slots = AvailabilityProvider.slotsFor(date)
        .where((slot) => !booked.contains(slot))
        .toList();

    if (slots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This date is full. Please choose another date.'),
        ),
      );
      return;
    }

    final time = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Choose a new time'),
        children: slots
            .map(
              (slot) => SimpleDialogOption(
                onPressed: () => Navigator.pop(dialogContext, slot),
                child: Text(slot),
              ),
            )
            .toList(),
      ),
    );

    if (time == null || !context.mounted) return;

    // "10:00 am" -> hour and minute
    final parts = time.split(' ');
    final hm = parts[0].split(':');
    var hour = int.parse(hm[0]);
    final minute = int.parse(hm[1]);
    if (parts[1] == 'pm' && hour != 12) hour += 12;
    if (parts[1] == 'am' && hour == 12) hour = 0;

    context.read<AppProvider>().rescheduleAppointment(
          appt.appointmentId,
          DateTime(date.year, date.month, date.day, hour, minute),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Your booking was moved. Waiting for the owner to confirm.',
        ),
      ),
    );
  }

  // UI-07b Late cancellation warning (same design as the wireframe).
  Widget _lateCancelDialog(BuildContext dialogContext, double deposit) {
    const bordeaux = Color(0xFF5B0015);
    const errorRed = Color(0xFFC62828);
    const ink = Color(0xFF2A1A1D);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: errorRed, size: 30),
                SizedBox(width: 10),
                Text(
                  'Late cancellation',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Your appointment is in less than 48 hours.',
              style: TextStyle(fontSize: 14, height: 1.5, color: ink),
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: ink,
                ),
                children: [
                  const TextSpan(
                    text: 'If you cancel now, your deposit of ',
                  ),
                  TextSpan(
                    text: 'RM ${deposit.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(
                    text: ' will not be returned. You must book again.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: bordeaux,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Keep my appointment'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: errorRed,
                  side: const BorderSide(color: errorRed, width: 1.5),
                  shape: const StadiumBorder(),
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Cancel anyway'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UI-07b: a cancel less than 48 hours before the appointment
  // shows the Late Cancellation pop-up (the deposit is not returned).
  Future<void> _askCancel(
    BuildContext context,
    AppointmentModel appt,
  ) async {
    final hoursLeft =
        appt.appointmentDateTime.difference(DateTime.now()).inHours;
    final isLate = hoursLeft < 48;

    // Deposit is at least 20% of the service price (FR-11).
    final deposit = (appt.servicePrice ?? 0) * 0.20;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => isLate
          ? _lateCancelDialog(dialogContext, deposit)
          : AlertDialog(
              title: const Text('Cancel Booking?'),
              content: const Text(
                'Do you want to cancel this booking? '
                'Your deposit is kept for you.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Keep Booking'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Yes, Cancel'),
                ),
              ],
            ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AppProvider>().updateAppointmentStatus(
            appt.appointmentId,
            AppointmentStatus.cancelled,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allAppointments =
        Provider.of<AppProvider>(context).appointments;

    // Each customer sees only their own bookings.
    // The owner (viewing as customer) sees all. A guest sees none.
    final user = AuthService.currentUser;
    final List<AppointmentModel> appointments = user == null
        ? <AppointmentModel>[]
        : user.isOwner
            ? allAppointments
            : allAppointments
                .where((a) => a.customerId == user.email)
                .toList();

    final bool isInsideDashboard =
        context.findAncestorWidgetOfExactType<CustomerDashboardScreen>() !=
            null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Slot'),
      ),
      body: appointments.isEmpty
          ? const Center(
              child: Text(
                'No appointments yet.\nBook a service to get started.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appt = appointments[index];

                return Card(
                  margin:
                      const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Text(
                              appt.customerName,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            Chip(
                              backgroundColor:
                                  const Color(0xFFDCE8F8),
                              label: Text(
                                appt.appointmentStatus,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          appt.customerPhone,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Appointment: '
                          '${appt.appointmentDateTime.day}/'
                          '${appt.appointmentDateTime.month}/'
                          '${appt.appointmentDateTime.year} '
                          '${appt.appointmentDateTime.hour > 12 ? appt.appointmentDateTime.hour - 12 : appt.appointmentDateTime.hour}:'
                          '${appt.appointmentDateTime.minute.toString().padLeft(2, '0')} '
                          '${appt.appointmentDateTime.hour >= 12 ? 'PM' : 'AM'}',
                        ),

                        const SizedBox(height: 8),

                        Text(
                          appt.depositPaid
                              ? 'Deposit Paid'
                              : context
                                      .watch<AppProvider>()
                                      .receiptFor(appt.appointmentId)
                                      .isNotEmpty
                                  ? 'Receipt sent. Waiting for the owner to check.'
                                  : 'Deposit Pending',
                          style: TextStyle(
                            color: appt.depositPaid
                                ? Colors.green
                                : Colors.orange,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (appt.designNotes != null &&
                            appt.designNotes!
                                .isNotEmpty)
                          Text(
                            'Notes: ${appt.designNotes}',
                          ),

                        const SizedBox(height: 12),

                        if (appt.appointmentStatus.toLowerCase() !=
                                AppointmentStatus.cancelled &&
                            appt.appointmentStatus.toLowerCase() !=
                                'rejected')
                          Wrap(
                            spacing: 8,
                            children: [
                              OutlinedButton(
                                onPressed: () =>
                                    _askReschedule(context, appt),
                                child: const Text('Reschedule'),
                              ),
                              OutlinedButton(
                                onPressed: () =>
                                    _askCancel(context, appt),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: isInsideDashboard
          ? null
          : NavigationBar(
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFFDCE8F8),
              selectedIndex: 1,
              onDestinationSelected: (index) {
                if (index == 1) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomerDashboardScreen(),
                  ),
                  (route) => false,
                );
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