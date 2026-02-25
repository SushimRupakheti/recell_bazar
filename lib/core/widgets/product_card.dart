import 'package:flutter/material.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';


class ProductCard extends StatelessWidget {
  final ItemEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ProductCard({
    super.key,
    required this.item,
    this.onTap,
    this.onFavoriteTap,
  });

  // ⭐ Rating Calculation
  double calculateRating() {
    final finalP = double.tryParse(item.finalPrice) ?? 0;
    final baseP = double.tryParse(item.basePrice) ?? 1;

    double rating = (finalP / baseP) * 5;

    if (rating > 5) rating = 5;
    if (rating < 0) rating = 0;

    return double.parse(rating.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    final rating = calculateRating();
    final sold = (item.isSold || (item.status ?? '').toLowerCase() == 'sold');

    return GestureDetector(
      onTap: sold ? null : onTap,
      child: Opacity(
        opacity: sold ? 0.6 : 1.0,
        child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Image (From Backend)
            AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: item.photos.isNotEmpty
                        ? Image.network(
                            item.photos.first,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(color: Colors.grey[200]),
                  ),

                  // Favorite Button (Optional - You can connect later)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite_border, size: 18),
                      ),
                    ),
                  ),
                  if (sold)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.blueGrey.shade700, borderRadius: BorderRadius.circular(8)),
                        child: const Text('SOLD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                    ),
                ],
              ),
            ),

            // ✅ Content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand / Category
                  Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Model Name
                  Text(
                    item.phoneModel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Final Price
                  Text(
                    'NPR ${item.finalPrice}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ⭐ Rating + Year
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        '${item.year}',
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
          ],
        ),
      ),
    )

    );
  }
}
