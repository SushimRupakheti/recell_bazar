import 'package:equatable/equatable.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';

enum ItemStatus { initial, loading, loaded, error, created, updated, deleted }

class ItemState extends Equatable {
   final ItemStatus status;
  final List<ItemEntity> items;          // all items
  final List<ItemEntity> cartItems;      // items in cart
  final List<ItemEntity> relatedItems;   // related items for a selected item
  final ItemEntity? selectedItem;        // item details
  final String? errorMessage;
  final String? uploadedPhotoUrl;
  final String? uploadedVideoUrl;

  const ItemState({
    this.status = ItemStatus.initial,
    this.items = const [],
    this.cartItems = const [],
    this.relatedItems = const [],
    this.selectedItem,
    this.errorMessage,
    this.uploadedPhotoUrl,
    this.uploadedVideoUrl,
  });

  ItemState copyWith({
    ItemStatus? status,
    List<ItemEntity>? items,
    List<ItemEntity>? cartItems,
    List<ItemEntity>? relatedItems,
    ItemEntity? selectedItem,
    bool resetSelectedItem = false,
    String? errorMessage,
    bool resetErrorMessage = false,
    String? uploadedPhotoUrl,
    bool resetUploadedPhotoUrl = false,
    String? uploadedVideoUrl,
    bool resetUploadedVideoUrl = false,
  }) {
    return ItemState(
      status: status ?? this.status,
      items: items ?? this.items,
      cartItems: cartItems ?? this.cartItems,
      relatedItems: relatedItems ?? this.relatedItems,
      selectedItem: resetSelectedItem ? null : (selectedItem ?? this.selectedItem),
      errorMessage: resetErrorMessage ? null : (errorMessage ?? this.errorMessage),
      uploadedPhotoUrl: resetUploadedPhotoUrl ? null : (uploadedPhotoUrl ?? this.uploadedPhotoUrl),
      uploadedVideoUrl: resetUploadedVideoUrl ? null : (uploadedVideoUrl ?? this.uploadedVideoUrl),
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        cartItems,
        relatedItems,
        selectedItem,
        errorMessage,
        uploadedPhotoUrl,
        uploadedVideoUrl,
      ];
}