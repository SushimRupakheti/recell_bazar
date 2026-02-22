import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:recell_bazar/features/item/presentation/providers/seller_item_provider.dart';
import 'package:recell_bazar/features/item/presentation/state/item_state.dart';
import 'package:recell_bazar/features/item/presentation/view_model/item_viewmodel.dart';
import 'package:recell_bazar/features/cart/presentation/providers/cart_provider.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';

class StatsCard extends ConsumerStatefulWidget {
  const StatsCard({super.key});

  @override
  ConsumerState<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends ConsumerState<StatsCard> {
  @override
  void initState() {
    super.initState();
    // Trigger load of cart and user items after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authViewModelProvider);
      final authId = authState.user?.authId;
      // Load cart items
      ref.read(itemViewModelProvider.notifier).getCartItems();
      if (authId != null) {
        ref.read(itemViewModelProvider.notifier).getItemsByUser(authId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final itemState = ref.watch(itemViewModelProvider);
    final cart = ref.watch(cartProvider);

    final authId = authState.user?.authId;

    // If we have an authenticated user but haven't loaded their items into
    // the ItemViewModel yet, trigger a fetch so counts reflect current data.
    if (authId != null) {
      final hasSellerItems = itemState.items.any((i) => i.sellerId == authId);
      if (!hasSellerItems && itemState.status != ItemStatus.loading) {
        Future.microtask(() => ref.read(itemViewModelProvider.notifier).getItemsByUser(authId));
      }
    }

    // Sold items count: items sold by current user
    final soldCount = authId == null
        ? 0
        : itemState.items.where((ItemEntity i) => i.sellerId == authId && i.isSold).length;

        // Listed items: use the same sellerItemsProvider as SellScreen so the
        // count matches what the seller screen displays (handles remote/local
        // sources and filtering).
        final listedCount = (() {
          if (authId == null) return 0;
          final sellerItemsAsync = ref.watch(sellerItemsProvider(authId));
          return sellerItemsAsync.maybeWhen(data: (items) => items.length, orElse: () => 0);
        })();

    final cartCount = cart.length;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(label: "Sold", value: soldCount.toString()),
          _StatItem(label: "Listed", value: listedCount.toString()),
          _StatItem(label: "Cart", value: cartCount.toString()),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(0xFF0B7C7C),
          child: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
