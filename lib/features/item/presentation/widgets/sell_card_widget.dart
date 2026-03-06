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
    // Status badge mapping
      // Status badge mapping. If item.isSold is true, override status to 'sold'.
      final status = item.isSold ? 'sold' : (item.status ?? 'pending').toLowerCase();
    Color statusColor;
    switch (status) {
      case 'approved':
        statusColor = Colors.green.shade700;
        break;
        case 'sold':
          statusColor = Colors.blueGrey.shade700;
          break;
      case 'rejected':
        statusColor = Colors.red.shade700;
        break;
      default:
        statusColor = const Color.fromARGB(255, 255, 230, 0); // pending or unknown
    }

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
          crossAxisAlignment: CrossAxisAlignment.center,
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

            // ✅ Price + status badge above it
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: const Offset(0, -6), // nudge badge slightly up
                  child: Container(
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "NPR ${item.finalPrice}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
