import 'package:flutter/material.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';

class SellCard extends StatelessWidget {
  final ItemEntity item;
  final VoidCallback? onTap;

  const SellCard({
    super.key,
    required this.item,
    this.onTap,
  });

  double _parsePrice(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  // ✅ Calculate rating dynamically (out of 5)
  double get rating {
    final base = _parsePrice(item.basePrice);
    final finalP = _parsePrice(item.finalPrice);

    if (base <= 0) return 0; // avoid division by zero

    var calculatedRating = (finalP / base) * 5;
    if (calculatedRating > 5) calculatedRating = 5; // cap at 5
    if (calculatedRating < 0) calculatedRating = 0;
    return double.parse(calculatedRating.toStringAsFixed(1)); // 1 decimal
  }

  String _resolveMediaUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final mediaBase = ApiEndpoints.baseUrl.replaceFirst('/api', '');
    return mediaBase + (path.startsWith('/') ? path : '/$path');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;

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
        statusColor = Colors.amber.shade700; // pending or unknown
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 104,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Image
              SizedBox(
                width: 86,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: item.photos.isNotEmpty
                      ? Image.network(
                          _resolveMediaUrl(item.photos.first),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: colorScheme.onSurface.withOpacity(0.08),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: colorScheme.onSurface.withOpacity(0.45),
                            ),
                          ),
                        )
                      : Container(
                          color: colorScheme.onSurface.withOpacity(0.08),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.phone_android_rounded,
                            color: colorScheme.onSurface.withOpacity(0.45),
                          ),
                        ),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.phoneModel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withOpacity(0.65),
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
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'NPR ${item.finalPrice}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
