import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'screens/owner_shell_screen.dart';
import 'providers/app_provider.dart';

import 'features/service_catalogue/providers/catalogue_provider.dart';
import 'features/booking/providers/booking_provider.dart';
import 'features/availability/providers/availability_provider.dart';
import 'features/design_preferences/providers/design_preferences_provider.dart';

// Lets the "Back to Owner" button move to another screen from anywhere.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const NagelApp());
}

class NagelApp extends StatelessWidget {
  const NagelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        ChangeNotifierProvider<CatalogueProvider>(
          create: (context) => CatalogueProvider(context.read<AppProvider>()),
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
        navigatorKey: navigatorKey,
        // Brand theme: Night Bordeaux, Cool Horizon, Ivory Mist, Lora and Poppins.
        theme: AppTheme.light,
        // While the owner views the customer screens, show a "Back to Owner" button.
        builder: (context, child) {
          return Stack(
            children: [
              child ?? const SizedBox.shrink(),
              ValueListenableBuilder<bool>(
                valueListenable: AuthService.ownerPreview,
                builder: (context, preview, _) {
                  if (!preview) return const SizedBox.shrink();
                  return Positioned(
                    left: 8,
                    top: 8,
                    child: SafeArea(
                      child: Material(
                        color: const Color(0xFF80AEE8),
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            AuthService.ownerPreview.value = false;
                            navigatorKey.currentState?.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const OwnerShellScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  size: 16,
                                  color: Color(0xFF5B0015),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Back to Owner',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5B0015),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
