// lib/screens/my_slot_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/appointment_model.dart';
import '../models/enums.dart';
import '../providers/app_provider.dart';
import 'customer_dashboard_screen.dart';

class MySlotScreen extends StatelessWidget {
  const MySlotScreen({super.key});

  // UI-07b: a cancel less than 48 hours before the appointment
  // shows the Late Cancellation pop-up (the deposit is not returned).
  Future<void> _askCancel(
    BuildContext context,
    AppointmentModel appt,
  ) async {
    final hoursLeft =
        appt.appointmentDateTime.difference(DateTime.now()).inHours;
    final isLate = hoursLeft < 48;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          isLate ? 'Late Cancellation' : 'Cancel Booking?',
        ),
        content: Text(
          isLate
              ? 'This is less than 48 hours before your appointment. '
                  'If you cancel now, your deposit is not returned.'
              : 'Do you want to cancel this booking? '
                  'Your deposit is kept for you.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              isLate ? 'Cancel Anyway' : 'Yes, Cancel',
            ),
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
    final appointments =
        Provider.of<AppProvider>(context).appointments;

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

                        if (appt.appointmentStatus !=
                            AppointmentStatus.cancelled)
                          Wrap(
                            spacing: 8,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const AlertDialog(
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