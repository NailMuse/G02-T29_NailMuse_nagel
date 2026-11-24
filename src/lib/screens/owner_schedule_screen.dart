// UI-08 Owner Schedule (FR-02, FR-03, FR-11, FR-14).
// Shows today's date and the REAL bookings made by customers.
// The owner can confirm or reject a booking and mark the deposit as paid.
// The low stock banner reads the real Inventory.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/appointment_model.dart';
import '../models/enums.dart';
import '../providers/app_provider.dart';
import '../widgets/owner_actions.dart';

// NailMuse official colour palette
const Color coolHorizon = Color(0xFF80AEE8);
const Color nightBordeaux = Color(0xFF5B0015);
const Color ivoryMist = Color(0xFFF7F2E0);

class OwnerScheduleScreen extends StatelessWidget {
  const OwnerScheduleScreen({super.key, this.embedded = false});

  /// true when this screen is shown inside OwnerShellScreen.
  /// The shell draws the bottom bar.
  final bool embedded;

  static const List<String> _days = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String _dateText(DateTime d) =>
      '${_days[d.weekday - 1]} ${d.day} ${_months[d.month - 1]} ${d.year}';

  static String _timeText(DateTime d) {
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'pm' : 'am';
    return '$hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    // Sort by date and time (earliest first).
    final appointments = List<AppointmentModel>.from(app.appointments)
      ..sort(
        (a, b) => a.appointmentDateTime.compareTo(b.appointmentDateTime),
      );

    final activeCount = appointments
        .where((a) => !_isClosed(a.appointmentStatus))
        .length;

    final lowStock = app.inventory.where((i) => i.isLowStock).toList();

    return Scaffold(
      backgroundColor: ivoryMist,
      appBar: AppBar(
        backgroundColor: nightBordeaux,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('My schedule'),
        actions: const [OwnerActions()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Today: ${_dateText(DateTime.now())}'),
              Text(
                activeCount == 1 ? '1 booking' : '$activeCount bookings',
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (appointments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No bookings yet.\nWhen a customer books, it shows here.',
                textAlign: TextAlign.center,
              ),
            )
          else
            for (final appt in appointments) ...[
              _AppointmentCard(
                appointment: appt,
                dateText: _dateText(appt.appointmentDateTime),
                timeText: _timeText(appt.appointmentDateTime),
              ),
              const SizedBox(height: 10),
            ],
          const SizedBox(height: 6),
          if (lowStock.isNotEmpty)
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Open the Inventory tab to restock.'),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: coolHorizon,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lowStock.length == 1
                          ? 'Low stock: ${lowStock.first.itemName} '
                              '(${lowStock.first.itemQuantity} left)'
                          : 'Low stock: ${lowStock.first.itemName} '
                              '(${lowStock.first.itemQuantity} left) '
                              'and ${lowStock.length - 1} more',
                      style: const TextStyle(
                        color: nightBordeaux,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Open the Inventory tab to restock',
                      style: TextStyle(color: nightBordeaux, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  static bool _isClosed(String status) {
    final s = status.toLowerCase();
    return s == AppointmentStatus.cancelled || s == 'rejected';
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final String dateText;
  final String timeText;

  const _AppointmentCard({
    required this.appointment,
    required this.dateText,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    final status = appointment.appointmentStatus.toLowerCase();
    final closed = status == AppointmentStatus.cancelled ||
        status == 'rejected';
    final confirmed = status == AppointmentStatus.confirmed;
    final provider = context.read<AppProvider>();
    final note = context.watch<AppProvider>().ownerNoteFor(
      appointment.appointmentId,
    );
    final receipt = context.watch<AppProvider>().receiptFor(
      appointment.appointmentId,
    );

    final statusLabel = status == AppointmentStatus.cancelled
        ? 'Cancelled by customer'
        : status == 'rejected'
            ? 'Rejected'
            : confirmed
                ? 'Confirmed'
                : 'Pending';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: closed ? const Color(0xFFEFEAD6) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$dateText, $timeText',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${appointment.customerName} | '
                      '${appointment.serviceName ?? 'Service'}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (appointment.customerPhone.isNotEmpty)
                      Text(
                        appointment.customerPhone,
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
              _chip(
                appointment.depositPaid ? 'Deposit paid' : 'Deposit pending',
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Status: $statusLabel',
            style: const TextStyle(fontSize: 12),
          ),
          if (receipt.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Receipt: $receipt',
              style: const TextStyle(fontSize: 12),
            ),
          ],
          if (note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Note: $note',
              style: const TextStyle(fontSize: 12),
            ),
          ],
          if (!closed) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _actionButton(
                  label: 'Confirm',
                  selected: confirmed,
                  onPressed: () => provider.updateAppointmentStatus(
                    appointment.appointmentId,
                    'Confirmed',
                  ),
                ),
                _actionButton(
                  label: 'Reject',
                  selected: false,
                  onPressed: () => provider.updateAppointmentStatus(
                    appointment.appointmentId,
                    'Rejected',
                  ),
                ),
                _actionButton(
                  label: note.isEmpty ? 'Add note' : 'Edit note',
                  selected: false,
                  onPressed: () => _editNote(context, provider, note),
                ),
                if (!appointment.depositPaid)
                  _actionButton(
                    label: 'Mark deposit paid',
                    selected: false,
                    onPressed: () => provider.markDepositPaid(
                      appointment.appointmentId,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // FR-12: the owner writes a private note for this appointment.
  Future<void> _editNote(
    BuildContext context,
    AppProvider provider,
    String current,
  ) async {
    final controller = TextEditingController(text: current);

    final saved = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Appointment note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'For example: customer wants a short nail shape',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved != null) {
      provider.setOwnerNote(appointment.appointmentId, saved);
    }
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: coolHorizon,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: nightBordeaux),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: nightBordeaux),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? coolHorizon : Colors.white,
        foregroundColor: nightBordeaux,
        side: const BorderSide(color: nightBordeaux),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label),
    );
  }
}
