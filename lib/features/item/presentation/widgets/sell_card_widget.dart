import 'package:flutter/material.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';

class SellCard extends StatelessWidget {
  final ItemEntity item;
  final VoidCallback? onTap;

  const SellCard({
    super.key,
    required this.item,
    this.onTap,
  });

  // ✅ Calculate rating dynamically (out of 5)
double get rating {
  // ✅ parse Strings to double
  double base = double.tryParse(item.basePrice) ?? 0;
  double finalP = double.tryParse(item.finalPrice) ?? 0;

  if (base == 0) return 0; // avoid division by zero

  double calculatedRating = (finalP / base) * 5;
  if (calculatedRating > 5) calculatedRating = 5; // cap at 5
  return double.parse(calculatedRating.toStringAsFixed(1)); // 1 decimal
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // ✅ Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item.photos.isNotEmpty
                  ? Image.network(
                      item.photos.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(width: 80, height: 80, color: Colors.grey),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey,
                    ),
            ),

            const SizedBox(width: 12),

            // ✅ Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.phoneModel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${item.year}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ✅ Price
            Text(
              "NPR ${item.finalPrice}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
