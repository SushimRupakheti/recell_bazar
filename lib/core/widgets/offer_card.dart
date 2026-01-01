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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
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
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  offer.discount,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B7C7C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer.title,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),

                Row(
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _indicator(isActive: index == activeIndex),
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

  Widget _indicator({required bool isActive}) {
    return Container(
      height: 2,
      width: 24,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
