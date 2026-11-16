
import 'package:flutter/material.dart';

import '../../../models/service_model.dart';
import 'service_card.dart';

class ServiceCategorySection extends StatelessWidget {
  final String title;
  final List<ServiceModel> services;
  final ValueChanged<ServiceModel>? onEdit;
  final ValueChanged<ServiceModel>? onDelete;

  const ServiceCategorySection({
    super.key,
    required this.title,
    required this.services,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 12,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF58372B),
            ),
          ),
        ),

        ...services.map(
          (service) => ServiceCard(
            service: service,
            onEdit: onEdit == null
                ? null
                : () => onEdit!(service),
            onDelete: onDelete == null
                ? null
                : () => onDelete!(service),
          ),
        ),
      ],
    );
  }
}
