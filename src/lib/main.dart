
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'screens/login_screen.dart';

import 'features/service_catalogue/providers/catalogue_provider.dart';
import 'features/booking/providers/booking_provider.dart';
import 'features/availability/providers/availability_provider.dart';
import 'features/design_preferences/providers/design_preferences_provider.dart';

void main() {
  runApp(const NagelApp());
}

class NagelApp extends StatelessWidget {
  const NagelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
          create: (_) => AppProvider(),
        ),
        ChangeNotifierProvider<CatalogueProvider>(
          create: (context) => CatalogueProvider(
            context.read<AppProvider>(),
          ),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (_) => BookingProvider(),
        ),
        ChangeNotifierProvider<AvailabilityProvider>(
          create: (_) => AvailabilityProvider(),
        ),
        ChangeNotifierProvider<DesignPreferencesProvider>(
          create: (_) => DesignPreferencesProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Nagel: Nail Business Management System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF80AEE8),
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F2E0),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
