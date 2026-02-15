import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/single_item_screen.dart';

import 'package:recell_bazar/models/offer_model.dart';
import 'package:recell_bazar/core/widgets/custom_choice_chip.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_items_by_category_usecase.dart';
import 'package:recell_bazar/core/widgets/offer_card.dart';
import 'package:recell_bazar/core/widgets/product_card.dart';
import 'package:recell_bazar/core/widgets/topbar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  List<ItemEntity> items = [];
  bool isLoading = true;
  String? errorMessage;
  String _selectedFilter = 'All';

  final _gap = const SizedBox(height: 12);

  final List<Offer> offers = [
    Offer(
      tag: '#brandsweek',
      discount: '50% off',
      title: 'On all Samsung Phones',
    ),
    Offer(
      tag: '#summerdeal',
      discount: '30% off',
      title: 'On all iPhones',
    ),
    Offer(
      tag: '#flashsale',
      discount: '20% off',
      title: 'On Vivo Phones',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(loadItems);
  }

  Future<void> loadItems() async {
    final usecase = ref.read(getAllItemsUsecaseProvider);

    final result = await usecase();

    result.fold(
      (failure) {
        setState(() {
          errorMessage = failure.message;
          isLoading = false;
        });
      },
      (data) {
        setState(() {
          items = data;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Top Bar
            const Topbar(),

            _gap,

            /// Filters
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: CustomChoiceChip(
                onDeviceTypeSelected: (type) async {
                  setState(() {
                    _selectedFilter = type;
                    isLoading = true;
                    errorMessage = null;
                  });

                  if (type == 'All') {
                    await loadItems();
                    return;
                  }

                  if (type == 'New In') {
                    // ensure we have items loaded
                    if (items.isEmpty) await loadItems();
                    setState(() => isLoading = false);
                    return;
                  }

                  // For brand/category filters, use the usecase
                  final usecase = ref.read(getItemsByCategoryUsecaseProvider);
                  final result = await usecase(type);
                  result.fold(
                    (failure) {
                      setState(() {
                        errorMessage = failure.message;
                        items = [];
                        isLoading = false;
                      });
                    },
                    (data) {
                      setState(() {
                        items = data;
                        isLoading = false;
                      });
                    },
                  );
                },
              ),
            ),

            /// Offers (hidden when a specific filter is active)
            if (_selectedFilter == 'All')
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: OfferCard(
                        offer: offers[index],
                        activeIndex: index,
                      ),
                    );
                  },
                ),
              ),

            /// Title
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Discover",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B7C7C),
                ),
              ),
            ),

            /// Grid Section
            Expanded(
              child: Builder(
                builder: (_) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (errorMessage != null) {
                    return Center(child: Text(errorMessage!));
                  }

                  if (items.isEmpty) {
                    return const Center(child: Text("No Items Found"));
                  }

                  // compute displayed items based on selected filter
                  List<ItemEntity> displayedItems;
                  if (_selectedFilter == 'All') {
                    displayedItems = items;
                  } else if (_selectedFilter == 'New In') {
                    // pick the single most recently created item (fallback to last)
                    if (items.isEmpty) {
                      displayedItems = [];
                    } else {
                      items.sort((a, b) {
                        final da = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                        final db = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                        return db.compareTo(da);
                      });
                      displayedItems = [items.first];
                    }
                  } else {
                    final q = _selectedFilter.toLowerCase();
                    displayedItems = items.where((it) {
                      final phone = it.phoneModel.toLowerCase();
                      final cat = it.category.toLowerCase();
                      return phone.contains(q) || cat.contains(q);
                    }).toList()
                      ..sort((a, b) {
                        final da = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                        final db = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                        return db.compareTo(da);
                      });
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: displayedItems.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        item: displayedItems[index],
                        onTap: () async {
                          final getItemUsecase = ref.read(getItemByIdUsecaseProvider);
                          final id = displayedItems[index].itemId;
                          if (id == null || id.isEmpty) {
                            // fallback: push with the item we already have
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SingleItemScreen(item: displayedItems[index]),
                              ),
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
                            (item) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SingleItemScreen(item: item),
                                ),
                              );
                            },
                          );
                        },
                        onFavoriteTap: () {},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
