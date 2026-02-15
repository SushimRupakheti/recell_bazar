import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/providers/cart_provider.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/single_item_screen.dart';

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    if (cart.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: cart.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return CartProduct(item: cart[index]);
      },
    );
  }
}

class CartProduct extends ConsumerWidget {
  final ItemEntity item;

  const CartProduct({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SingleItemScreen(item: item)),
        );
      },
      child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 238, 238),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.photos.isNotEmpty
                ? Image.network(
                    item.photos.first,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 72, height: 72, color: Colors.grey.shade300),
                  )
                : Container(
                    width: 72,
                    height: 72,
                    color: Colors.grey.shade300,
                  ),
          ),

          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 88, 88, 88),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.phoneModel,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      // simple rating derived from price ratio
                      ((double.tryParse(item.finalPrice) ?? 0) / (double.tryParse(item.basePrice) ?? 1) * 5)
                          .clamp(0, 5)
                          .toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      '${item.year} GB',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Remove item'),
                      content: const Text('Are you sure you want to remove this item from the cart?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Remove')),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    ref.read(cartProvider.notifier).removeItem(item.itemId);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item removed from cart')));
                  }
                },
                child: const Icon(Icons.delete_outline, size: 20),
              ),
              const SizedBox(height: 16),
              Text(
                'NPR ${item.finalPrice}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
