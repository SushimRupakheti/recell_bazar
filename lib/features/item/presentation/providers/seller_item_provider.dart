import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_items_by_seller_usecase.dart';

final sellerItemsProvider =
    FutureProvider.family<List<ItemEntity>, String>((ref, sellerId) async {
  final usecase = ref.read(getItemsBySellerUsecaseProvider);

  final result = await usecase(sellerId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (items) {
      // Defensive filter: ensure only items that actually belong to the requested
      // sellerId are returned. Handles backends returning nested seller objects
      // or unfiltered lists.
      final normRequested = sellerId.trim().toLowerCase();
      final filtered = items.where((it) {
        try {
          return (it.sellerId).trim().toLowerCase() == normRequested;
        } catch (_) {
          return false;
        }
      }).toList();

      return filtered;
    },
  );
});
