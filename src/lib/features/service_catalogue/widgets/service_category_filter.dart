// The row of category buttons (All, Gel Manicure, Extensions ...).
// Used by BOTH the owner Service Catalogue (UI-11) and the customer
// Choose Service screen (UI-02), so the two screens look the same.

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class ServiceCategoryFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const ServiceCategoryFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const Map<String, String> categories = {
    'all': 'All',
    'gel': 'Gel Manicure',
    'extensions': 'Extensions',
    'addon': 'Add-ons',
    'removal': 'Removal',
    'henna': 'Henna',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: categories.entries.map((entry) {
          final isSelected = selected == entry.key;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              selectedColor: AppColors.coolHorizon,
              backgroundColor: AppColors.skyTint,
              labelStyle: const TextStyle(
                color: AppColors.nightBordeaux,
                fontWeight: FontWeight.w500,
              ),
              onSelected: (_) => onSelected(entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}
