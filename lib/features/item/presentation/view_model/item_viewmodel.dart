import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/domain/usecases/create_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_items_by_category_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/update_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_items_by_seller_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/upload_photo_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/upload_video_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/search_item_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_related_items_usecase.dart';
// import 'package:recell_bazar/features/item/domain/usecases/mark_item_as_sold_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/add_to_cart_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/remove_from_cart_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_cart_items_usecase.dart';
import 'package:recell_bazar/features/item/presentation/state/item_state.dart';


final itemViewModelProvider = NotifierProvider<ItemViewModel, ItemState>(
  ItemViewModel.new,
);

class ItemViewModel extends Notifier<ItemState> {
  late final GetAllItemsUsecase _getAllItemsUsecase;
  late final GetItemByIdUsecase _getItemByIdUsecase;
  late final GetItemsBySellerUsecase _getItemsBySellerUsecase;
  late final CreateItemUsecase _createItemUsecase;
  late final UpdateItemUsecase _updateItemUsecase;
  late final DeleteItemUsecase _deleteItemUsecase;
  late final UploadPhotoUsecase _uploadPhotoUsecase;
  late final UploadVideoUsecase _uploadVideoUsecase;
  late final SearchItemsUsecase _searchItemsUsecase;
  late final GetItemsByCategoryUsecase _getItemsByCategoryUsecase;
  late final GetRelatedItemsUsecase _getRelatedItemsUsecase;
  // late final MarkItemAsSoldUsecase _markItemAsSoldUsecase;
  late final AddToCartUsecase _addToCartUsecase;
  late final RemoveFromCartUsecase _removeFromCartUsecase;
  late final GetCartItemsUsecase _getCartItemsUsecase;

  @override
  ItemState build() {
    _getAllItemsUsecase = ref.read(getAllItemsUsecaseProvider);
    _getItemByIdUsecase = ref.read(getItemByIdUsecaseProvider);
    _getItemsBySellerUsecase = ref.read(getItemsBySellerUsecaseProvider);
    _createItemUsecase = ref.read(createItemUsecaseProvider);
    _updateItemUsecase = ref.read(updateItemUsecaseProvider);
    _deleteItemUsecase = ref.read(deleteItemUsecaseProvider);
    _uploadPhotoUsecase = ref.read(uploadPhotoUsecaseProvider);
    _uploadVideoUsecase = ref.read(uploadVideoUsecaseProvider);
    _searchItemsUsecase = ref.read(searchItemsUsecaseProvider);
    _getItemsByCategoryUsecase = ref.read(getItemsByCategoryUsecaseProvider);
    _getRelatedItemsUsecase = ref.read(getRelatedItemsUsecaseProvider);
    // _markItemAsSoldUsecase = ref.read(markItemAsSoldUsecaseProvider);
    _addToCartUsecase = ref.read(addToCartUsecaseProvider);
    _removeFromCartUsecase = ref.read(removeFromCartUsecaseProvider);
    _getCartItemsUsecase = ref.read(getCartItemsUsecaseProvider);

    return const ItemState();
  }

  // ---------------- CORE ITEM FUNCTIONS ----------------

  Future<void> getAllItems() async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _getAllItemsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ItemStatus.loaded,
        items: items,
      ),
    );
  }

  Future<void> getItemById(String itemId) async {
    state = state.copyWith(status: ItemStatus.loading);

  final result = await _getItemByIdUsecase(GetItemByIdParams(itemId: itemId));

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (item) => state = state.copyWith(
        status: ItemStatus.loaded,
        selectedItem: item,
      ),
    );
  }

  Future<void> getItemsByUser(String userId) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _getItemsBySellerUsecase(userId);

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ItemStatus.loaded,
        items: items,
      ),
    );
  }

Future<void> createItem({
  required String sellerId,
  required List<String> photos,
  required String category,
  required String phoneModel,
  required int year,
  required String finalPrice,
  required String basePrice,
  required int batteryHealth,
  required String description,
  required bool chargerAvailable,

  required bool factoryUnlock,
  required bool liquidDamage,
  required bool switchOn,
  required bool receiveCall,
  required bool features1Condition,
  required bool features2Condition,
  required bool cameraCondition,
  required bool displayCondition,
  required bool displayCracked,
  required bool displayOriginal,
}) async {
  state = state.copyWith(status: ItemStatus.loading);

  final result = await _createItemUsecase(
    CreateItemParams(
      sellerId: sellerId,
      photos: photos,
      category: category,
        phoneModel: phoneModel,
      year: year,
      finalPrice: finalPrice,
      basePrice: basePrice,
      batteryHealth: batteryHealth,
      description: description,
      chargerAvailable: chargerAvailable,

      factoryUnlock: factoryUnlock,
      liquidDamage: liquidDamage,
      switchOn: switchOn,
      receiveCall: receiveCall,
      features1Condition: features1Condition,
      features2Condition: features2Condition,
      cameraCondition: cameraCondition,
      displayCondition: displayCondition,
      displayCracked: displayCracked,
      displayOriginal: displayOriginal,
    ),
  );

  result.fold(
    (failure) => state = state.copyWith(
      status: ItemStatus.error,
      errorMessage: failure.message,
    ),
    (success) {
      state = state.copyWith(status: ItemStatus.created);
      getAllItems();
    },
  );
}


Future<void> updateItem({
  required String itemId,
  required String sellerId,
  required List<String> photos,
  required String category,
  required String phoneModel,
  required int year,
  required String finalPrice,
  required String basePrice,
  required int batteryHealth,
  required String description,
  required bool chargerAvailable,
  // Boolean evaluation questions
  required bool factoryUnlock,
  required bool liquidDamage,
  required bool switchOn,
  required bool receiveCall,
  required bool features1Condition,
  required bool features2Condition,
  required bool cameraCondition,
  required bool displayCondition,
  required bool displayCracked,
  required bool displayOriginal,
}) async {
  state = state.copyWith(status: ItemStatus.loading);

  final result = await _updateItemUsecase(
    UpdateItemParams(
      itemId: itemId,
      photos: photos,
      category: category,
        phoneModel: phoneModel,
      year: year,
      finalPrice: finalPrice,
      basePrice: basePrice,
      batteryHealth: batteryHealth,
      description: description,
      chargerAvailable: chargerAvailable,
      factoryUnlock: factoryUnlock,
      liquidDamage: liquidDamage,
      switchOn: switchOn,
      receiveCall: receiveCall,
      features1Condition: features1Condition,
      features2Condition: features2Condition,
      cameraCondition: cameraCondition,
      displayCondition: displayCondition,
      displayCracked: displayCracked,
      displayOriginal: displayOriginal,
    ),
  );

  result.fold(
    (failure) => state = state.copyWith(
      status: ItemStatus.error,
      errorMessage: failure.message,
    ),
    (success) {
      state = state.copyWith(status: ItemStatus.updated);
      getAllItems(); // Refresh the list after updating
    },
  );
}


  Future<void> deleteItem(String itemId) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _deleteItemUsecase(DeleteItemParams(itemId: itemId));

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: ItemStatus.deleted);
        getAllItems();
      },
    );
  }

  // ---------------- MEDIA UPLOAD ----------------

  Future<String?> uploadPhoto(File photo) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _uploadPhotoUsecase(photo);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ItemStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        state = state.copyWith(
          status: ItemStatus.loaded,
          uploadedPhotoUrl: url,
        );
        return url;
      },
    );
  }

  Future<String?> uploadVideo(File video) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _uploadVideoUsecase(video);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ItemStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        state = state.copyWith(
          status: ItemStatus.loaded,
          uploadedVideoUrl: url,
        );
        return url;
      },
    );
  }

  // ---------------- SEARCH / FILTER ----------------

  Future<void> searchItems({String? phoneModel, String? category}) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _searchItemsUsecase(
      SearchItemsParams(phoneModel: phoneModel, category: category),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ItemStatus.loaded,
        items: items,
      ),
    );
  }

  Future<void> getItemsByCategory(String categoryId) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _getItemsByCategoryUsecase(categoryId);

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ItemStatus.loaded,
        items: items,
      ),
    );
  }

  // ---------------- RELATED ITEMS ----------------

  Future<void> getRelatedItems(String itemId) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _getRelatedItemsUsecase(itemId);

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ItemStatus.loaded,
        relatedItems: items,
      ),
    );
  }

  // ---------------- MARK SOLD ----------------

// Future<void> markItemAsSold(String itemId) async {
//   state = state.copyWith(status: ItemStatus.loading);

//   final result = await _markItemAsSoldUsecase(itemId);

//   result.fold(
//     (failure) => state = state.copyWith(
//       status: ItemStatus.error,
//       errorMessage: failure.message,
//     ),
//     (success) {
//       // Update the selectedItem if it matches
//       final updatedSelectedItem = state.selectedItem?.itemId == itemId
//           ? state.selectedItem!.copyWith(
//               extraAnswers: {
//                 ...?state.selectedItem!.extraAnswers,
//                 'isSold': true,
//               },
//             )
//           : state.selectedItem;

//       // Update items list as well
//       final updatedItems = state.items.map((item) {
//         if (item.itemId == itemId) {
//           return item.copyWith(
//             extraAnswers: {
//               ...?item.extraAnswers,
//               'isSold': true,
//             },
//           );
//         }
//         return item;
//       }).toList();

//       state = state.copyWith(
//         status: ItemStatus.updated,
//         selectedItem: updatedSelectedItem,
//         items: updatedItems,
//       );
//     },
//   );
// }

  // ---------------- CART ----------------

  Future<void> addToCart(String itemId) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _addToCartUsecase(itemId);

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (success) => getCartItems(),
    );
  }

  Future<void> removeFromCart(String itemId) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _removeFromCartUsecase(itemId);

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (success) => getCartItems(),
    );
  }

  Future<void> getCartItems() async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _getCartItemsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ItemStatus.loaded,
        cartItems: items,
      ),
    );
  }

  // ---------------- UTILS ----------------

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void clearSelectedItem() {
    state = state.copyWith(resetSelectedItem: true);
  }

  void clearReportState() {
    state = state.copyWith(
      status: ItemStatus.initial,
      resetUploadedPhotoUrl: true,
      resetUploadedVideoUrl: true,
      resetErrorMessage: true,
    );
  }
}
