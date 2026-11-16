
import 'package:flutter/material.dart';

import 'customer_dashboard_screen.dart';
import 'owner_dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const Color burgundy = Color(0xFF590019);
  static const Color cream = Color(0xFFF7F2E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.spa,
                size: 75,
                color: burgundy,
              ),
              const SizedBox(height: 16),
              const Text(
                'nägel',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: burgundy,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nail Business Management System',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.brown),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: burgundy,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CustomerDashboardScreen(),
                      ),
                    );
                  },
                  child: const Text('Continue as Customer'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: burgundy,
                    side: const BorderSide(color: burgundy),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const OwnerDashboardScreen(),
                      ),
                    );
                  },
                  child: const Text('Continue as Owner'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
