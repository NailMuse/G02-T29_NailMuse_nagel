
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
              const Text(
                'Owner schedule',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 8),

              // Header
              Container(
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: nightBordeaux,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'My schedule',
                  style: TextStyle(
                    color: ivoryMist,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Date and booking count
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tues 10 Nov 2026'),
                  Text('3 bookings'),
                ],
              ),

              const SizedBox(height: 12),

              // Appointment 1
              const AppointmentCard(
                time: '7.00pm',
                customer: 'Aisyah',
                service: 'Classic gel',
                deposit: 'Deposit paid',
                selectedAction: 'Confirm',
              ),

              const SizedBox(height: 10),

              // Appointment 2
              const AppointmentCard(
                time: '8.00pm',
                customer: 'Meimei',
                service: 'Builder gel',
                deposit: 'Deposit pending',
                selectedAction: 'Confirm',
              ),

              const SizedBox(height: 10),

              // Appointment 3
              const AppointmentCard(
                time: '9.00pm',
                customer: 'Jess',
                service: 'Manicure',
                deposit: 'No Deposit',
                selectedAction: 'Reject',
              ),

              const SizedBox(height: 16),

              // Low stock notification
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Restock feature coming soon.'),
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low stock gel base coat (2 left)',
                        style: TextStyle(
                          color: nightBordeaux,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to restock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: coolHorizon,
        unselectedItemColor: Colors.black87,
        selectedFontSize: 12,
        unselectedFontSize: 12,

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
            label: 'MySchedule',
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
  final String selectedAction;

  const AppointmentCard({
    super.key,
    required this.time,
    required this.customer,
    required this.service,
    required this.deposit,
    required this.selectedAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      '$customer | $service',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: coolHorizon,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: nightBordeaux),
                ),
                child: Text(
                  deposit,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Appointment action buttons
          Wrap(
            spacing: 8,
            runSpacing: 4,
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
    final isSelected = label == selectedAction;

    return OutlinedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label action will be implemented later.'),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? coolHorizon : Colors.white,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label),
    );
  }
}
