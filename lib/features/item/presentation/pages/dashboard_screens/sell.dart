import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/phone_brand_selection_screen.dart';
import 'package:recell_bazar/features/item/presentation/providers/seller_item_provider.dart';
import 'package:recell_bazar/features/item/presentation/widgets/sell_card_widget.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/single_item_screen.dart';
import 'package:recell_bazar/l10n/app_localizations.dart';

class SellScreen extends ConsumerWidget {
  final String sellerId;

  const SellScreen({
    super.key,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final itemsAsync = ref.watch(sellerItemsProvider(sellerId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myListings), centerTitle: true),
      body: SafeArea(
        child: itemsAsync.when(
          loading: () => Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: colorScheme.error,
                    size: 38,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Failed to load your listings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$e',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.65),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.refresh(
                      sellerItemsProvider(sellerId).future,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  await ref.refresh(sellerItemsProvider(sellerId).future);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
                  children: [
                    const SizedBox(height: 140),
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 52,
                      color: colorScheme.onSurface.withOpacity(0.55),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'No items posted yet',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap + to create your first listing.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await ref.refresh(sellerItemsProvider(sellerId).future);
              },
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 8, bottom: 120),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return SellCard(
                    item: item,
                    onTap: () async {
                      final getItemUsecase = ref.read(
                        getItemByIdUsecaseProvider,
                      );
                      final id = item.itemId;
                      if (id == null || id.isEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SingleItemScreen(item: item),
                          ),
                        );
                        return;
                      }

                      final result =
                          await getItemUsecase(GetItemByIdParams(itemId: id));
                      result.fold(
                        (failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to load item: ${failure.message}',
                              ),
                            ),
                          );
                        },
                        (freshItem) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SingleItemScreen(item: freshItem),
                            ),
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
        backgroundColor: colorScheme.primary,
      ),
    );
  }
}
