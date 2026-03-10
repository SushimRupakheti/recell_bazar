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
    final sold = item.isSold || (item.status ?? '').toLowerCase() == 'sold';

    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: sold ? null : onTap,
      child: Opacity(
        opacity: sold ? 0.6 : 1.0,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth;

            // Responsive values
            final bool isTabletCard = cardWidth >= 220;
            final double imageHeight = isTabletCard ? 180 : 150;
            final double horizontalPadding = isTabletCard ? 12 : 10;
            final double verticalPadding = isTabletCard ? 10 : 8;
            final double categoryFont = isTabletCard ? 12 : 11;
            final double titleFont = isTabletCard ? 16 : 14;
            final double priceFont = isTabletCard ? 15 : 13;
            final double metaFont = isTabletCard ? 13 : 12;
            final double favRadius = isTabletCard ? 18 : 16;
            final double favIconSize = isTabletCard ? 20 : 18;

            return Container(
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(isDark ? 0.18 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section
                  SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: item.photos.isNotEmpty
                              ? Image.network(
                                  item.photos.first,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: colorScheme.onSurface.withOpacity(0.05),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 32,
                                        color: colorScheme.onSurface.withOpacity(0.4),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: colorScheme.onSurface.withOpacity(0.05),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 32,
                                    color: colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                ),
                        ),

                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: onFavoriteTap,
                            child: CircleAvatar(
                              radius: favRadius,
                              backgroundColor:
                                  isDark ? colorScheme.surface : Colors.white,
                              child: Icon(
                                Icons.favorite_border,
                                size: favIconSize,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),

                        if (sold)
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade700,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'SOLD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Content section
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: categoryFont,
                              color: colorScheme.onSurface.withOpacity(0.65),
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            item.phoneModel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: titleFont,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'NPR ${item.finalPrice}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: priceFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),

                          Row(
                            children: [
                              const Icon(Icons.star, size: 15),
                              const SizedBox(width: 4),
                              Text(
                                rating.toString(),
                                style: TextStyle(
                                  fontSize: metaFont,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${item.year}',
                                style: TextStyle(
                                  fontSize: metaFont,
                                  color: colorScheme.onSurface.withOpacity(0.65),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}