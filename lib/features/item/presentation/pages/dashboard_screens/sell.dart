import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/phone_brand_selection_screen.dart';
import 'package:recell_bazar/features/item/presentation/providers/seller_item_provider.dart';
import 'package:recell_bazar/features/item/presentation/widgets/sell_card_widget.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/single_item_screen.dart';

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
      // appBar: AppBar(
      //   title: const Text("My Listings"),
      // ),
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
            return RefreshIndicator(
              onRefresh: () async {
                await ref.refresh(sellerItemsProvider(sellerId).future);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("No items posted yet")),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(sellerItemsProvider(sellerId).future);
            },
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];

                return SellCard(
                  item: item,
                  onTap: () async {
                    final getItemUsecase = ref.read(getItemByIdUsecaseProvider);
                    final id = item.itemId;
                    if (id == null || id.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SingleItemScreen(item: item)),
                      );
                      return;
                    }

                    final result = await getItemUsecase(GetItemByIdParams(itemId: id));
                    result.fold(
                      (failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to load item: ${failure.message}')),
                        );
                      },
                      (freshItem) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SingleItemScreen(item: freshItem)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),

      // Floating Add Button (Like Screenshot)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneBrandSelectionScreen(),
                            ),
                          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF0B7C7C),
      ),
    );
  }
}
