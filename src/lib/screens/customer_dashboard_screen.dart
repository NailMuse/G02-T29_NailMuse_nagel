
import 'package:flutter/material.dart';

import '../features/ai_assistant/screens/nail_muse_ai_screen.dart';
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

// The Nail Muse AI screen (UI-06) now lives in
// features/ai_assistant/screens/nail_muse_ai_screen.dart.
// This small class keeps the old name so other screens still work.
class NailMuseAiPlaceholder extends StatelessWidget {
  const NailMuseAiPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => const NailMuseAiScreen();
}
