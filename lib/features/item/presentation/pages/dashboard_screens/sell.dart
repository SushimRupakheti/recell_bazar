import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/phone_brand_selection_screen.dart';
import 'package:recell_bazar/features/item/presentation/providers/seller_item_provider.dart';
import 'package:recell_bazar/features/item/presentation/widgets/sell_card_widget.dart';

class SellScreen extends ConsumerWidget {
  final String sellerId;

  const SellScreen({
    super.key,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(sellerItemsProvider(sellerId));

    // Debug: log requested sellerId
    debugPrint('SellScreen: requested sellerId=$sellerId');

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Listings"),
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text("Error: $e"),
        ),

        data: (items) {
          // Defensive filter: ensure only items with matching sellerId are shown
          final filtered = items.where((i) => i.sellerId.toLowerCase() == sellerId.toLowerCase()).toList();

          debugPrint('SellScreen: fetched ${items.length} items, filtered to ${filtered.length} for sellerId=$sellerId');
          for (var it in filtered) debugPrint('  item ${it.itemId} sellerId=${it.sellerId}');

          if (filtered.isEmpty) {
            return const Center(
              child: Text("No items posted yet"),
            );
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];

              return SellCard(
                item: item,
                onTap: () {
                  // Navigate to detail if needed
                },
              );
            },
          );
        },
      ),

      // ✅ Floating Add Button (Like Screenshot)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneBrandSelectionScreen(),
                            ),
                          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
