import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/item/data/repositories/item_repository.dart';

class CartNotifier extends StateNotifier<List<ItemEntity>> {
  final Ref _ref;

  CartNotifier(this._ref) : super([]) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      final ids = prefs.getStringList('cart_items') ?? <String>[];
      if (ids.isEmpty) return;
      final repo = _ref.read(itemRepositoryProvider);
      final List<ItemEntity> items = [];
      for (final id in ids) {
        final res = await repo.getItemById(id);
        res.fold((_) {}, (item) => items.add(item));
      }
      if (items.isNotEmpty) state = items;
    } catch (_) {}
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      final ids = state.where((i) => i.itemId != null).map((i) => i.itemId!).toList();
      await prefs.setStringList('cart_items', ids);
    } catch (_) {}
  }

  void addItem(ItemEntity item) {
    if (item.itemId != null && state.any((i) => i.itemId == item.itemId)) return;
    state = [...state, item];
    _saveToPrefs();
  }

  void removeItem(String? itemId) {
    if (itemId == null) return;
    state = state.where((i) => i.itemId != itemId).toList();
    _saveToPrefs();
  }

  bool contains(String? itemId) {
    if (itemId == null) return false;
    return state.any((i) => i.itemId == itemId);
  }

  void clear() {
    state = [];
    _saveToPrefs();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<ItemEntity>>((ref) {
  return CartNotifier(ref);
});
