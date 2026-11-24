// src/lib/features/availability/screens/working_hours_screen.dart
// FR-02 Manage Appointment Availability | UI-09 Working Hours (owner view)
// Owner bottom bar tab: "Hours". Written by Aida.
//
// Shows the salon opening hours and lets the owner switch a day Open / Closed.
// The hours below are the team's latest understanding and are still to be
// confirmed with the client (Ms. Michelle):
//   Monday to Friday: 7:00 pm - 10:00 pm
//   Saturday, Sunday and public holidays: 10:00 am - 7:00 pm
// Open / Closed (Monday to Sunday) is kept in AvailabilityProvider while the
// app is open. Saving to the database comes later.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/owner_actions.dart';
import '../providers/availability_provider.dart';

class WorkingHoursScreen extends StatefulWidget {
  const WorkingHoursScreen({super.key});

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}

class _DayHours {
  final String day;
  final String hours;
  bool isOpen = true;

  _DayHours(this.day, this.hours);
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  static const Color _ivoryMist = Color(0xFFF7F2E0);
  static const Color _nightBordeaux = Color(0xFF5B0015);
  static const Color _coolHorizon = Color(0xFF80AEE8);
  static const Color _border = Color(0xFFD9D2BC);

  static const String _weekdayHours = '7:00 pm - 10:00 pm';
  static const String _weekendHours = '10:00 am - 7:00 pm';

  final List<_DayHours> _days = [
    _DayHours('Monday', _weekdayHours),
    _DayHours('Tuesday', _weekdayHours),
    _DayHours('Wednesday', _weekdayHours),
    _DayHours('Thursday', _weekdayHours),
    _DayHours('Friday', _weekdayHours),
    _DayHours('Saturday', _weekendHours),
    _DayHours('Sunday', _weekendHours),
    _DayHours('Public holiday', _weekendHours),
  ];

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _dateText(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  // The owner closes the salon for a period, for example a holiday.
  Future<void> _addClosedDates(AvailabilityProvider availability) async {
    final now = DateTime.now();

    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Choose the closed dates',
    );

    if (range == null || !mounted) return;

    final controller = TextEditingController();

    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reason (optional)'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'For example: Holiday',
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

    if (reason == null) return;

    availability.addClosedPeriod(range.start, range.end, reason);
  }

  Widget _closedDatesSection(AvailabilityProvider availability) {
    final periods = availability.closedPeriods;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Closed dates (holiday)',
            style: TextStyle(
              color: _nightBordeaux,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Customers cannot book on these dates.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          if (periods.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No closed dates yet.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          for (var n = 0; n < periods.length; n++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                periods[n].start == periods[n].end
                    ? _dateText(periods[n].start)
                    : '${_dateText(periods[n].start)} - '
                        '${_dateText(periods[n].end)}',
              ),
              subtitle: periods[n].reason.isEmpty
                  ? null
                  : Text(periods[n].reason),
              trailing: IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => availability.removeClosedPeriod(n),
              ),
            ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: _nightBordeaux,
                side: const BorderSide(color: _nightBordeaux),
                shape: const StadiumBorder(),
              ),
              onPressed: () => _addClosedDates(availability),
              icon: const Icon(Icons.event_busy),
              label: const Text('Add closed dates'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availability = context.watch<AvailabilityProvider>();

    return Scaffold(
      backgroundColor: _ivoryMist,
      appBar: AppBar(
        backgroundColor: _nightBordeaux,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Working Hours'),
        actions: const [OwnerActions()],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _days.length + 2,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          if (i == _days.length) {
            return _closedDatesSection(availability);
          }
          if (i == _days.length + 1) {
            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Hours are to be confirmed with the client. '
                'Open and Closed are saved while the app is open. '
                'A closed day cannot be chosen by customers.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            );
          }
          final d = _days[i];
          // Monday to Sunday are saved in the provider. Public holiday is not.
          final isOpen = i < 7 ? availability.isDayOpen(i + 1) : d.isOpen;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.day,
                        style: const TextStyle(
                          color: _nightBordeaux,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isOpen ? d.hours : 'Closed',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  isOpen ? 'Open' : 'Closed',
                  style: const TextStyle(fontSize: 12),
                ),
                Switch(
                  value: isOpen,
                  activeThumbColor: _nightBordeaux,
                  activeTrackColor: _coolHorizon,
                  onChanged: (value) {
                    if (i < 7) {
                      availability.setDayOpen(i + 1, value);
                    } else {
                      setState(() {
                        d.isOpen = value;
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
