import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/features/cart/domain/entities/cart_models.dart';
import 'package:recell_bazar/features/cart/presentation/state/cart_state.dart';
import 'package:recell_bazar/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:recell_bazar/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    final cartLabel = l10n?.cart ?? 'Cart';
    final cartState = ref.watch(cartViewModelProvider);
    final cart = cartState.cart;
    final items = cart?.items ?? const <CartItem>[];

    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final surface = colorScheme.surface;
    final shadowColor = Theme.of(context).shadowColor;

    return Scaffold(
      appBar: AppBar(title: Text(cartLabel), centerTitle: true),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: colorScheme.error,
                        size: 36,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cartState.errorMessage ?? 'Failed to load cart',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(cartViewModelProvider.notifier)
                            .fetchCart(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 46,
                        color: colorScheme.onSurface.withOpacity(0.55),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your cart is empty',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Add items to see them here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final cartItem = items[index];
                      final product = cartItem.productSnapshot;

                      final title = product?.phoneModel ?? 'Product';
                      final category = product?.category ?? '';
                      final photo = (product?.photos.isNotEmpty ?? false)
                          ? _resolveMediaUrl(product!.photos.first)
                          : '';

                      final cardStart = Color.alphaBlend(
                        primary.withOpacity(0.06),
                        surface,
                      );
                      final cardEnd = Color.alphaBlend(
                        primary.withOpacity(0.03),
                        surface,
                      );

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {},
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: primary.withOpacity(0.14),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [cardStart, cardEnd],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 78,
                                      height: 78,
                                      child: photo.isNotEmpty
                                          ? Image.network(
                                              photo,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                    color: colorScheme.onSurface
                                                        .withOpacity(0.08),
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      color: colorScheme
                                                          .onSurface
                                                          .withOpacity(0.40),
                                                    ),
                                                  ),
                                            )
                                          : Container(
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.08),
                                              child: Icon(
                                                Icons.image_outlined,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.40),
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (category.isNotEmpty)
                                          Text(
                                            category,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.62),
                                            ),
                                          ),
                                        if (category.isNotEmpty)
                                          const SizedBox(height: 2),
                                        Text(
                                          title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'NPR ${_formatPrice(cartItem.priceAtTime)}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      tooltip: 'More',
                                      onSelected: (value) async {
                                        if (value != 'delete') return;

                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Remove item'),
                                            content: const Text(
                                              'Remove this item from your cart?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                  ctx,
                                                ).pop(false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(true),
                                                child: const Text('Remove'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmed != true) return;

                                        final failure = await ref
                                            .read(
                                              cartViewModelProvider.notifier,
                                            )
                                            .removeCartItem(cartItem.id);

                                        if (!context.mounted) return;

                                        if (failure == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Cart item removed',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final msg = failure.message;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(msg),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      },
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: colorScheme.error,
                                                ),
                                                const SizedBox(width: 8),
                                                const Text('Delete'),
                                              ],
                                            ),
                                          ),
                                        ];
                                      },
                                      icon: Icon(
                                        Icons.more_vert_rounded,
                                        color: colorScheme.onSurface
                                            .withOpacity(0.55),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: surface,
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor.withOpacity(0.05),
                        blurRadius: 14,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${items.length} item${items.length == 1 ? '' : 's'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.60),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'NPR ${_formatPrice(cart?.totalPrice ?? 0)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: primary,
                        ),
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
