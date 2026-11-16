import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class SwitchRoleButton extends StatelessWidget {
  const SwitchRoleButton({super.key});

  void _returnToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Switch Role / Log Out',
      icon: const Icon(Icons.logout_rounded),
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Switch View?'),
            content: const Text(
              'Return to the login screen to switch between Customer and Owner views?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Stay'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _returnToLogin(context);
                },
                child: const Text('Switch'),
              ),
            ],
          ),
        );
      },
    );
  }
}