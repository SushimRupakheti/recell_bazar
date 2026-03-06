import 'package:equatable/equatable.dart';

class ItemSnapshot extends Equatable {
  final String id;
  final String phoneModel;
  final String category;
  final List<String> photos;
  final String finalPrice;
  final String status;

  const ItemSnapshot({
    required this.id,
    required this.phoneModel,
    required this.category,
    required this.photos,
    required this.finalPrice,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        phoneModel,
        category,
        photos,
        finalPrice,
        status,
      ];
}
