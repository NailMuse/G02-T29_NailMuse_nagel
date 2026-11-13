import 'package:flutter/material.dart';

class CustomerBottomNavBar extends StatelessWidget {
  /// 0 = Book Now, 1 = My Slot, 2 = Nail Muse Ai
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomerBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  static const Color _coolHorizon = Color(0xFF80AEE8);
  static const Color _unselectedCircle = Color(0xFFE5E5E5);
  static const Color _darkInk = Color(0xFF23191B);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0x14000000)),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                index: 0,
                icon: Icons.calendar_today_outlined,
                label: 'Book Now',
              ),
              _buildTabItem(
                index: 1,
                icon: Icons.assignment_outlined,
                label: 'My Slot',
              ),
              _buildTabItem(
                index: 2,
                icon: Icons.auto_awesome_outlined,
                label: 'Nail Muse Ai',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap?.call(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? _coolHorizon : _unselectedCircle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 19,
                color: _darkInk,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: _darkInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}