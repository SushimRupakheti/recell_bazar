import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/cart/domain/entities/cart_models.dart';
import 'package:recell_bazar/features/cart/presentation/state/cart_state.dart';
import 'package:recell_bazar/features/cart/presentation/view_model/cart_viewmodel.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartViewModelProvider.notifier).fetchCart();
    });
  }

  String _resolveMediaUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final mediaBase = ApiEndpoints.baseUrl.replaceFirst('/api', '');
    return mediaBase + (path.startsWith('/') ? path : '/$path');
  }

  String _formatPrice(double value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);
    final cart = cartState.cart;
    final items = cart?.items ?? const <CartItem>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (cartState.status == CartStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (cartState.status == CartStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(cartState.errorMessage ?? 'Failed to load cart'),
                ),
              );
            }

            if (items.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final cartItem = items[index];
                      final product = cartItem.productSnapshot;

                      final title = product?.phoneModel ?? 'Product';
                      final category = product?.category ?? '';
                      final photo = (product?.photos.isNotEmpty ?? false)
                          ? _resolveMediaUrl(product!.photos.first)
                          : '';

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 238, 238),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: photo.isNotEmpty
                                  ? Image.network(
                                      photo,
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 72,
                                        height: 72,
                                        color: Colors.grey.shade300,
                                      ),
                                    )
                                  : Container(
                                      width: 72,
                                      height: 72,
                                      color: Colors.grey.shade300,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (category.isNotEmpty)
                                    Text(
                                      category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 88, 88, 88),
                                      ),
                                    ),
                                  const SizedBox(height: 2),
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Price at time: NPR ${_formatPrice(cartItem.priceAtTime)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Remove item'),
                                    content: const Text('Remove this item from your cart?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(true),
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed != true) return;

                                final failure = await ref
                                    .read(cartViewModelProvider.notifier)
                                    .removeCartItem(cartItem.id);

                                if (!context.mounted) return;

                                if (failure == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Cart item removed')),
                                  );
                                  return;
                                }

                                final msg = failure.message;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(msg),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              child: const Icon(Icons.delete_outline, size: 20),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'NPR ${_formatPrice(cart?.totalPrice ?? 0)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
