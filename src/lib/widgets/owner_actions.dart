// Two icons for the top right of every owner screen:
// 1) "View as customer" (so the owner can test the customer screens)
// 2) Log out
// Written for UI-08 to UI-11.

import 'package:flutter/material.dart';

import '../features/auth/services/auth_service.dart';
import '../features/auth/widgets/logout_button.dart';
import '../screens/customer_dashboard_screen.dart';

class OwnerActions extends StatelessWidget {
  const OwnerActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'View as customer',
          icon: const Icon(Icons.visibility_outlined),
          onPressed: () {
            AuthService.ownerPreview.value = true;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const CustomerDashboardScreen(),
              ),
              (route) => false,
            );
          },
        ),
        const LogoutButton(),
      ],
    );
  }
}
