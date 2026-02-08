import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:state_notifier/state_notifier.dart';

class CartNotifier extends StateNotifier<List<ItemEntity>> {
  CartNotifier() : super([]);

  void addItem(ItemEntity item) {
    // avoid duplicates by itemId if present
    if (item.itemId != null && state.any((i) => i.itemId == item.itemId)) return;
    state = [...state, item];
  }

  void removeItem(String? itemId) {
    if (itemId == null) return;
    state = state.where((i) => i.itemId != itemId).toList();
  }

  bool contains(String? itemId) {
    if (itemId == null) return false;
    return state.any((i) => i.itemId == itemId);
  }

  void clear() => state = [];
}

final cartProvider = StateNotifierProvider<CartNotifier, List<ItemEntity>>((ref) {
  return CartNotifier();
});
