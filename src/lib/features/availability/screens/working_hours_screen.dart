// src/lib/features/availability/screens/working_hours_screen.dart
// FR-02 Manage Appointment Availability | UI-09 Working Hours (owner view)
// Owner bottom bar tab: "Hours". Written by Aida.
//
// Shows the salon opening hours and lets the owner switch a day Open / Closed.
// The hours below are the team's latest understanding and are still to be
// confirmed with the client (Ms. Michelle):
//   Monday to Friday: 7:00 pm - 10:00 pm
//   Saturday, Sunday and public holidays: 8:00 am - 10:00 pm
// Saving to the database comes later. For now the switches only change this screen.

import 'package:flutter/material.dart';

import '../../auth/widgets/logout_button.dart';

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
  static const String _weekendHours = '8:00 am - 10:00 pm';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ivoryMist,
      appBar: AppBar(
        backgroundColor: _ivoryMist,
        elevation: 0,
        title: const Text(
          'Working Hours',
          style: TextStyle(color: _nightBordeaux, fontWeight: FontWeight.bold),
        ),
        actions: const [LogoutButton()],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _days.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          if (i == _days.length) {
            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Hours are to be confirmed with the client. '
                'Changes are not saved yet.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            );
          }
          final d = _days[i];
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
                        d.isOpen ? d.hours : 'Closed',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  d.isOpen ? 'Open' : 'Closed',
                  style: const TextStyle(fontSize: 12),
                ),
                Switch(
                  value: d.isOpen,
                  activeThumbColor: _nightBordeaux,
                  activeTrackColor: _coolHorizon,
                  onChanged: (value) {
                    setState(() {
                      d.isOpen = value;
                    });
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
