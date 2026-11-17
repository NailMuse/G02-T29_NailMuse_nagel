// src/lib/screens/owner_shell_screen.dart
// Owner bottom bar (UI-08 to UI-11). Written by Aida.
// After the owner logs in, this screen opens. The bar has 4 tabs and
// each tab shows one owner screen:
//   My Schedule -> OwnerScheduleScreen (UI-08)
//   Hours       -> WorkingHoursScreen (UI-09)
//   Inventory   -> InventoryScreen (UI-10)
//   Service     -> ServiceCatalogueScreen (UI-11)
// The customer side uses the same idea in customer_dashboard_screen.dart.

import 'package:flutter/material.dart';

import '../features/availability/screens/working_hours_screen.dart';
import '../features/inventory/screens/inventory_screen.dart';
import '../features/service_catalogue/screens/service_catalogue_screen.dart';
import 'owner_schedule_screen.dart';

class OwnerShellScreen extends StatefulWidget {
  const OwnerShellScreen({super.key});

  @override
  State<OwnerShellScreen> createState() => _OwnerShellScreenState();
}

class _OwnerShellScreenState extends State<OwnerShellScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    OwnerScheduleScreen(embedded: true),
    WorkingHoursScreen(),
    InventoryScreen(),
    ServiceCatalogueScreen(),
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
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'My Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time),
            selectedIcon: Icon(Icons.access_time_filled),
            label: 'Hours',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Service',
          ),
        ],
      ),
    );
  }
}
