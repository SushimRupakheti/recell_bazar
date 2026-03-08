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
import 'package:recell_bazar/features/notification/presentation/pages/notifications_screen.dart';
import 'package:recell_bazar/features/notification/presentation/view_model/notification_viewmodel.dart';
import 'package:recell_bazar/l10n/app_localizations.dart';

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
  String _searchQuery = '';

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

    // Fetch notifications once so the bell can show an unread indicator.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(notificationViewModelProvider.notifier).fetchNotifications();
    });
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
    final l10n = AppLocalizations.of(context)!;
    final notificationState = ref.watch(notificationViewModelProvider);
    final hasUnread = notificationState.notifications.any((n) => !n.isRead);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Top Bar
            Topbar(
              onSearch: (query) {
                setState(() => _searchQuery = query.trim());
              },
              showUnreadDot: hasUnread,
              onNotificationsTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ).then((_) {
                  // Refresh from server when returning, so the dot stays in sync.
                  if (!mounted) return;
                  ref.read(notificationViewModelProvider.notifier).fetchNotifications();
                });
              },
            ),

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
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                l10n.discover,
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
                    return Center(child: Text(l10n.noItemsFound));
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

                  // Only show approved items in the dashboard
                  displayedItems = displayedItems.where((it) => (it.status ?? 'pending').toLowerCase() == 'approved').toList();

                  // Apply search query filter by model and category
                  if (_searchQuery.isNotEmpty) {
                    final q = _searchQuery.toLowerCase();
                    displayedItems = displayedItems.where((it) {
                      final model = it.phoneModel.toLowerCase();
                      final cat = it.category.toLowerCase();
                      return model.contains(q) || cat.contains(q);
                    }).toList();
                  }

return LayoutBuilder(
  builder: (context, constraints) {
    final width = constraints.maxWidth;

    int crossAxisCount;
    double childAspectRatio;

    if (width >= 1100) {
      crossAxisCount = 5;
      childAspectRatio = 0.78;
    } else if (width >= 850) {
      crossAxisCount = 4;
      childAspectRatio = 0.76;
    } else if (width >= 600) {
      crossAxisCount = 3;
      childAspectRatio = 0.72;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 0.68;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: displayedItems.length,
      itemBuilder: (context, index) {
        return ProductCard(
          item: displayedItems[index],
          onTap: () async {
            final getItemUsecase = ref.read(getItemByIdUsecaseProvider);
            final id = displayedItems[index].itemId;

            if (id == null || id.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SingleItemScreen(item: displayedItems[index]),
                ),
              );
              return;
            }

            final result = await getItemUsecase(
              GetItemByIdParams(itemId: id),
            );

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
