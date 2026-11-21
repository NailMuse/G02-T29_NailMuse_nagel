// lib/screens/my_slot_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/appointment_model.dart';
import '../providers/app_provider.dart';

class MySlotScreen extends StatelessWidget {
  const MySlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = context.watch<AppProvider>().appointments;

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
                              label: Text(
                                appt.appointmentStatus,
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
                          'Appointment: ${appt.appointmentDateTime}',
                        ),

                        const SizedBox(height: 8),

                        Text(
                          appt.depositPaid
                              ? 'Deposit Paid'
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

                        Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      const AlertDialog(
                                    title: Text(
                                      'Reschedule Policy',
                                    ),
                                    content: Text(
                                      'Rescheduling or cancellation must be done at least 48 hours before the appointment.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Reschedule'),
                            ),
                            if (appt.appointmentStatus.toLowerCase() !=
                                'cancelled')
                              OutlinedButton(
                                onPressed: () =>
                                    _cancelAppointment(context, appt),
                                child: const Text('Cancel Appointment'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _cancelAppointment(
    BuildContext context,
    AppointmentModel appointment,
  ) async {
    const cancellationNotice =
        'Appointments can only be cancelled at least 48 hours before the scheduled date and time.';
    final timeUntilAppointment =
        appointment.appointmentDateTime.difference(DateTime.now());

    if (timeUntilAppointment < const Duration(hours: 48)) {
      await _showCancellationPolicy(context, cancellationNotice);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel appointment?'),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep Appointment'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cancel Appointment'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Recheck after confirmation in case the appointment crossed the cutoff.
    final remainingTime =
        appointment.appointmentDateTime.difference(DateTime.now());
    if (remainingTime < const Duration(hours: 48)) {
      await _showCancellationPolicy(context, cancellationNotice);
      return;
    }

    context.read<AppProvider>().updateAppointmentStatus(
          appointment.appointmentId,
          'cancelled',
        );
  }

  Future<void> _showCancellationPolicy(
    BuildContext context,
    String message,
  ) {
    if (!context.mounted) return Future<void>.value();

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancellation unavailable'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
