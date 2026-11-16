
import 'package:flutter/material.dart';

import '../../../models/service_model.dart';

class BookingServiceCard extends StatelessWidget {
  final ServiceModel service;
  final bool isSelected;
  final VoidCallback onSelect;

  const BookingServiceCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onSelect,
  });

  static const Color burgundy = Color(0xFF590019);
  static const Color brown = Color(0xFF58372B);
  static const Color thumbnailBlue = Color(0xFF80AEE8);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? burgundy
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Service image placeholder
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: thumbnailBlue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.spa,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(width: 12),

            // Service information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.serviceName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.serviceDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RM ${service.servicePrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: brown,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            // Select button
            OutlinedButton(
              onPressed: onSelect,
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    isSelected ? Colors.white : Colors.black,
                backgroundColor:
                    isSelected ? burgundy : Colors.white,
                side: const BorderSide(
                  color: Colors.black54,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder(),
              ),
              child: Text(
                isSelected ? 'Selected' : 'Select',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
