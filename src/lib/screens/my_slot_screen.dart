// lib/screens/my_slot_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class MySlotScreen extends StatelessWidget {
  const MySlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments =
        Provider.of<AppProvider>(context).appointments;

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
                          child:
                              const Text('Reschedule'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}