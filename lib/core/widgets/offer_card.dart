import 'package:flutter/material.dart';
import 'package:recell_bazar/models/offer_model.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final int activeIndex; 

  const OfferCard({
    super.key,
    required this.offer,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Theme.of(context).dividerColor.withOpacity(0.35)
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.tag,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.65),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  offer.discount,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.92),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _indicator(context, isActive: index == activeIndex),
                    );
                  }),
                ),
              ],
            ),
          ),

          Container(
            height: 44,
            width: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0B7C7C),
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _indicator(BuildContext context, {required bool isActive}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 2,
      width: 24,
      decoration: BoxDecoration(
        color: isActive
            ? (isDark
                ? colorScheme.onSurface.withOpacity(0.95)
                : Colors.black)
            : (isDark
                ? colorScheme.onSurface.withOpacity(0.20)
                : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
