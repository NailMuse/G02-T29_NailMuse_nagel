
import 'package:flutter/material.dart';

class DesignOptionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const DesignOptionCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  static const Color burgundy = Color(0xFF590019);
  static const Color blue = Color(0xFF80AEE8);
  static const Color brown = Color(0xFF58372B);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: isSelected ? blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? burgundy : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : brown,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
