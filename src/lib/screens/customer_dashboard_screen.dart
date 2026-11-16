
import 'package:flutter/material.dart';

import '../features/booking/screens/choose_service_screen.dart';
import 'my_slot_screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState
    extends State<CustomerDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ChooseServiceScreen(),
    MySlotScreen(),
    NailMuseAiPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCE8F8),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
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

class NailMuseAiPlaceholder extends StatelessWidget {
  const NailMuseAiPlaceholder({super.key});

  static const Color burgundy = Color(0xFF590019);
  static const Color cream = Color(0xFFF7F2E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: burgundy,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Nail Muse AI'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 60,
                color: burgundy,
              ),
              SizedBox(height: 16),
              Text(
                'Nail Muse AI',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: burgundy,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your nail design assistant is coming soon.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
