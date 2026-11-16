
import 'package:flutter/material.dart';

// NailMuse official colour palette
const Color coolHorizon = Color(0xFF80AEE8);
const Color nightBordeaux = Color(0xFF5B0015);
const Color ivoryMist = Color(0xFFF7F2E0);

class OwnerScheduleScreen extends StatefulWidget {
  const OwnerScheduleScreen({super.key});

  @override
  State<OwnerScheduleScreen> createState() =>
      _OwnerScheduleScreenState();
}

class _OwnerScheduleScreenState
    extends State<OwnerScheduleScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivoryMist,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Page label
              const Text(
                'Owner schedule',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 12),

              // Header
              Container(
                height: 65,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: nightBordeaux,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'My schedule',
                  style: TextStyle(
                    color: ivoryMist,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Date and booking count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: nightBordeaux,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Tues 10 Nov 2026',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: nightBordeaux,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: coolHorizon.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '3 bookings',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: nightBordeaux,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Appointment 1
              const AppointmentCard(
                time: '7.00pm',
                customer: 'Aisyah',
                service: 'Classic gel',
                deposit: 'Deposit paid',
              ),

              const SizedBox(height: 12),

              // Appointment 2
              const AppointmentCard(
                time: '8.00pm',
                customer: 'Meimei',
                service: 'Builder gel',
                deposit: 'Deposit pending',
              ),

              const SizedBox(height: 12),

              // Appointment 3
              const AppointmentCard(
                time: '9.00pm',
                customer: 'Jess',
                service: 'Manicure',
                deposit: 'No Deposit',
              ),

              const SizedBox(height: 20),

              // Low stock notification
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Restock feature coming soon.',
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: coolHorizon.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: coolHorizon,
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: nightBordeaux,
                        size: 28,
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Low stock alert',
                              style: TextStyle(
                                color: nightBordeaux,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              'Gel base coat (2 left)',
                              style: TextStyle(
                                color: nightBordeaux,
                                fontSize: 13,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              'Tap to restock',
                              style: TextStyle(
                                color: nightBordeaux,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.arrow_forward_ios,
                        color: nightBordeaux,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: nightBordeaux,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        elevation: 8,

        onTap: (index) {
          if (index == 0) {
            setState(() {
              _selectedIndex = index;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${['My Schedule', 'Hours', 'Inventory', 'Service'][index]} screen is not connected yet.',
                ),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'My Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Hours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Service',
          ),
        ],
      ),
    );
  }
}

// Reusable appointment card
class AppointmentCard extends StatelessWidget {
  final String time;
  final String customer;
  final String service;
  final String deposit;

  const AppointmentCard({
    super.key,
    required this.time,
    required this.customer,
    required this.service,
    required this.deposit,
  });

  @override
  Widget build(BuildContext context) {
    // Deposit badge colours
    final Color badgeBackground;
    final Color badgeText;

    if (deposit == 'Deposit paid') {
      badgeBackground = const Color(0xFFDDF3E4);
      badgeText = const Color(0xFF246B3B);
    } else if (deposit == 'Deposit pending') {
      badgeBackground = const Color(0xFFFFF0CC);
      badgeText = const Color(0xFF946200);
    } else {
      badgeBackground = const Color(0xFFEEEEEE);
      badgeText = const Color(0xFF555555);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time and deposit status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: nightBordeaux,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      customer,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      service,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // Deposit badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: badgeBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  deposit,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: badgeText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(height: 1),

          const SizedBox(height: 12),

          // Appointment action buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _actionButton(context, 'Confirm'),
              _actionButton(context, 'Reschedule'),
              _actionButton(context, 'Reject'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label) {
    return OutlinedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$label action will be implemented later.',
            ),
          ),
        );
      },

      style: OutlinedButton.styleFrom(
        backgroundColor: label == 'Confirm'
            ? coolHorizon
            : Colors.white,
        foregroundColor: label == 'Confirm'
            ? nightBordeaux
            : Colors.black87,
        side: BorderSide(
          color: label == 'Reject'
              ? nightBordeaux.withValues(alpha: 0.6)
              : Colors.black26,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
