
import 'package:flutter/material.dart';

import '../../../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ServiceCard({
    super.key,
    required this.service,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final description = service.serviceDescription;
    final priceRange = RegExp(
      r'Price range: (RM\d+-RM\d+)',
    ).firstMatch(description);

    final displayedPrice = priceRange != null
        ? priceRange.group(1)!.replaceAll('-', ' – ')
        : 'RM${service.servicePrice.toStringAsFixed(0)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8DDD5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.serviceName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF58372B),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description.split('. Price range:').first,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF89766D),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  displayedPrice,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF58372B),
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit service',
            ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete service',
              color: Colors.redAccent,
            ),
        ],
      ),
    );
  }
}
