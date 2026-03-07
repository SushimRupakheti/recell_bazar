import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:uuid/uuid.dart';
import 'package:recell_bazar/features/payment/presentation/providers/payment_provider.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:recell_bazar/features/payment/domain/entities/payment_request.dart';
import 'package:recell_bazar/core/api/api_client.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/features/item/presentation/providers/seller_item_provider.dart';

class SingleItemScreen extends ConsumerStatefulWidget {
  final ItemEntity item;

  const SingleItemScreen({super.key, required this.item});

  @override
  ConsumerState<SingleItemScreen> createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends ConsumerState<SingleItemScreen> {
  final PageController _pageController = PageController();
  int _activeIndex = 0;

  late ItemEntity _currentItem;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  void _showBookingSheet() {
    final userSession = ref.read(userSessionServiceProvider);
    final defaultFirst = userSession.getFirstName() ?? '';
    final defaultLast = userSession.getUserLastName() ?? '';
    final defaultFullName = (defaultFirst + ' ' + defaultLast).trim();
    final defaultEmail = userSession.getUserEmail() ?? '';
    final defaultPhone = userSession.getUserPhoneNumber() ?? '';
    final defaultAddress = userSession.getUserAddress() ?? '';

    const locationOptions = <String>[
      'Imadol, Lalitpur',
      'Newroad, Kathmandu',
      'Gundu, Bhaktapur',
    ];

    final now = DateTime.now();
    final earliestDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    var selectedLocation = locationOptions.contains(defaultAddress)
        ? defaultAddress
        : locationOptions.first;

    final priceInt =
        int.tryParse(
          _currentItem.finalPrice.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;

    final dateCtrl = TextEditingController(
      text: earliestDate.toIso8601String().split('T').first,
    );
    final timeCtrl = TextEditingController(text: '4:00 PM');

    final fullNameCtrl = TextEditingController(text: defaultFullName);
    final numberCtrl = TextEditingController(text: defaultPhone);
    final emailCtrl = TextEditingController(text: defaultEmail);
    final phoneModelCtrl = TextEditingController(text: widget.item.phoneModel);
    final priceCtrl = TextEditingController(text: priceInt.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Answer The Questions Below:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Shop
                      const Text(
                        'Shop:',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedLocation,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        items: locationOptions
                            .map(
                              (loc) => DropdownMenuItem<String>(
                                value: loc,
                                child: Text(loc),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) return;
                          setModalState(() {
                            selectedLocation = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: dateCtrl,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Date',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onTap: () async {
                                final parsed = DateTime.tryParse(dateCtrl.text);
                                final initial =
                                    (parsed != null &&
                                        !parsed.isBefore(earliestDate))
                                    ? parsed
                                    : earliestDate;

                                final dt = await showDatePicker(
                                  context: ctx,
                                  initialDate: initial,
                                  firstDate: earliestDate,
                                  lastDate: DateTime(2100),
                                );
                                if (dt != null) {
                                  dateCtrl.text = dt
                                      .toIso8601String()
                                      .split('T')
                                      .first;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 120,
                            child: TextField(
                              controller: timeCtrl,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Time',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onTap: () async {
                                final t = await showTimePicker(
                                  context: ctx,
                                  initialTime: const TimeOfDay(
                                    hour: 16,
                                    minute: 0,
                                  ),
                                );
                                if (t != null) timeCtrl.text = t.format(ctx);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Text(
                        'Buyer Info:',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: fullNameCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: numberCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: phoneModelCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Phone Model',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: priceCtrl,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B7C7C),
                              ),
                              onPressed: () async {
                                final enteredEmail = emailCtrl.text.trim();
                                if (enteredEmail.isEmpty) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter an email address',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                await _submitBooking(
                                  location: selectedLocation,
                                  date: dateCtrl.text,
                                  time: timeCtrl.text,
                                  fullName: fullNameCtrl.text,
                                  number: numberCtrl.text,
                                  email: enteredEmail,
                                  phoneModel: phoneModelCtrl.text,
                                  price:
                                      int.tryParse(
                                        priceCtrl.text.replaceAll(
                                          RegExp(r'[^0-9]'),
                                          '',
                                        ),
                                      ) ??
                                      priceInt,
                                );
                                Navigator.of(ctx).pop();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  'Finish',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitBooking({
    required String location,
    required String date,
    required String time,
    required String fullName,
    required String number,
    required String email,
    required String phoneModel,
    required int price,
  }) async {
    final id =
        'BK-${DateTime.now().millisecondsSinceEpoch}-${Uuid().v4().substring(0, 6)}';

    final request = PaymentRequest(
      amount: price,
      productName: widget.item.phoneModel,
      productId: widget.item.itemId ?? '',
      buyerName: fullName,
      customerEmail: email,
      buyerPhone: number,
      orderId: id,
      fullName: fullName,
      phoneNo: number,
      phoneModel: phoneModel,
      sellerId: widget.item.sellerId,
      price: price,
      location: location,
      date: date,
      time: time,
      oid: id,
      refId: id,
    );

    await ref.read(paymentControllerProvider).initiatePayment(context, request);

    // After payment flow completes, re-fetch item detail from server to confirm sold status.
    Future.delayed(const Duration(seconds: 2), () async {
      final id = widget.item.itemId;
      if (id == null || id.isEmpty) return;
      final getItemUsecase = ref.read(getItemByIdUsecaseProvider);
      final result = await getItemUsecase(GetItemByIdParams(itemId: id));
      result.fold(
        (failure) {
          // ignore: avoid_print
          print('Failed to refresh item: ${failure.message}');
        },
        (fresh) {
          setState(() {
            _currentItem = fresh;
          });

          if (_currentItem.isSold ||
              (_currentItem.status ?? '').toLowerCase() == 'sold') {
            showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Item sold'),
                content: const Text(
                  'This item has been marked sold by the server after payment. We\'re updating the UI.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
      );
    });
  }

  Future<void> _showStripeConfigDialog(String details) async {
    // Configuration dialog moved to payment provider. No-op kept for compatibility.
    return;
  }

  @override
  Widget build(BuildContext context) {
    final photos = _currentItem.photos;
    final hasPhotos = photos.isNotEmpty;

    final currentUserId = ref.read(userSessionServiceProvider).getUserId();
    final isOwner =
        currentUserId != null && currentUserId == _currentItem.sellerId;
    final isSold =
        _currentItem.isSold ||
        (_currentItem.status ?? '').toLowerCase() == 'sold';
    final disablePurchaseActions = isSold || isOwner;

    // You can replace these with real fields from ItemEntity if you have them
    final rating = 4.5;

    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ===== TOP IMAGE CARD (with back + bag icons) =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  children: [
                    Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.surface : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: hasPhotos
                            ? PageView.builder(
                                controller: _pageController,
                                itemCount: photos.length,
                                onPageChanged: (i) =>
                                    setState(() => _activeIndex = i),
                                itemBuilder: (_, i) {
                                  return Image.network(
                                    photos[i],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.broken_image, size: 40),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),

                    // Back
                    Positioned(
                      left: 10,
                      top: 10,
                      child: _TopIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),

                    // removed top-right bag icon per request

                    // 3-dot menu (only for the item owner)
                    if (ref.read(userSessionServiceProvider).getUserId() ==
                        _currentItem.sellerId)
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            shape: BoxShape.circle,
                          ),
                          child: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.black87,
                            ),
                            padding: EdgeInsets.zero,
                            onSelected: (value) async {
                              if (value == 'delete') {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete Item'),
                                    content: Text(
                                      'Are you sure you want to delete "${_currentItem.phoneModel}"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(true),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed != true) return;
                                final id = _currentItem.itemId;
                                if (id == null || id.isEmpty) return;

                                try {
                                  final apiClient = ref.read(apiClientProvider);
                                  final response = await apiClient.delete(
                                    ApiEndpoints.itemById(id),
                                  );

                                  if (response.data['success'] == true) {
                                    if (mounted) {
                                      // Refresh the seller items list
                                      ref.invalidate(
                                        sellerItemsProvider(
                                          _currentItem.sellerId,
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Item deleted successfully',
                                          ),
                                        ),
                                      );
                                      Navigator.of(
                                        context,
                                      ).pop(); // Go back after deletion
                                    }
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Failed to delete item',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ===== DOT INDICATOR =====
              if (hasPhotos) ...[
                const SizedBox(height: 10),
                Center(
                  child: _Dots(count: photos.length, active: _activeIndex),
                ),
              ] else ...[
                const SizedBox(height: 10),
                Center(
                  child: _Dots(count: 5, active: 0),
                ), // screenshot-like placeholder
              ],

              const SizedBox(height: 14),

              // ===== SMALL BRAND LABEL =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Iphone",
                  style: TextStyle(color: isDark ? colorScheme.onSurface.withOpacity(0.7) : Colors.grey.shade600, fontSize: 13),
                ),
              ),

              const SizedBox(height: 8),

              // ===== TITLE + PRICE =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _currentItem.phoneModel.isNotEmpty
                            ? _currentItem.phoneModel
                            : "Item",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "NPR${_currentItem.finalPrice}",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // ===== RATING + STORAGE =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 16, color: colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onBackground),
                    ),
                    const SizedBox(width: 10),

                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ===== DEVICE CONDITION =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  "Device Condition",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.7,
                  children: [
                    _ConditionTile(
                      label: "Screen",
                      value: widget.item.displayOriginal ? "Perfect" : "Used",
                      icon: Icons.phone_iphone,
                      bg: const Color(0xFFE7F7EF),
                      iconColor: const Color(0xFF2BB673),
                    ),
                    _ConditionTile(
                      label: "Battery",
                      value: "${widget.item.batteryHealth}%",
                      icon: Icons.battery_full,
                      bg: const Color(0xFFEAF2FF),
                      iconColor: const Color(0xFF2F6BFF),
                    ),
                    _ConditionTile(
                      label: "Camera",
                      value: widget.item.cameraCondition
                          ? "Need Replacement"
                          : "Excellent",
                      icon: Icons.photo_camera_outlined,
                      bg: const Color(0xFFF2E9FF),
                      iconColor: const Color(0xFF7C3AED),
                    ),
                    _ConditionTile(
                      label: "Charger",
                      value: widget.item.chargerAvailable ? "Original" : "No",
                      icon: Icons.bolt,
                      bg: const Color(0xFFFFF3E6),
                      iconColor: const Color(0xFFF97316),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ===== DESCRIPTION + MODEL YEAR =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentItem.description.isNotEmpty
                          ? _currentItem.description
                          : "No description available.",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Model Year",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentItem.year.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== BOTTOM BAR BUTTONS =====
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOwner)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      colorScheme.primary.withOpacity(0.10),
                      colorScheme.surface,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This is your own listing',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shadowColor: colorScheme.primary.withOpacity(0.25),
                      ),
                      onPressed: disablePurchaseActions
                          ? null
                          : () => _showBookingSheet(),
                      child: Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isDark ? colorScheme.surface : colorScheme.background,
                        side: BorderSide(color: colorScheme.primary, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        foregroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shadowColor: colorScheme.primary.withOpacity(0.15),
                      ),
                      onPressed: disablePurchaseActions
                          ? null
                          : () {
                              final productId = _currentItem.itemId;
                              if (productId == null || productId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid product id'),
                                  ),
                                );
                                return;
                              }

                              () async {
                                final failure = await ref
                                    .read(cartViewModelProvider.notifier)
                                    .addToCart(productId);

                                if (!context.mounted) return;

                                if (failure == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart'),
                                    ),
                                  );
                                  return;
                                }

                                String message = failure.message;
                                if (failure is ApiFailure) {
                                  switch (failure.statusCode) {
                                    case 401:
                                      message = 'Unauthorized';
                                      break;
                                    case 409:
                                      message = 'Already in cart';
                                      break;
                                    case 400:
                                    case 403:
                                    case 404:
                                      // Show backend message as-is
                                      message = failure.message;
                                      break;
                                  }
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    backgroundColor: Colors.red,
                                  ),
                                );

                                if (failure is ApiFailure &&
                                    failure.statusCode == 401) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                }
                              }();
                            },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.black, size: 20),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int active;

  const _Dots({required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    final safeCount = count.clamp(1, 8); // keeps it neat like screenshot
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(safeCount, (i) {
        final isActive = i == (active.clamp(0, safeCount - 1));
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: isActive ? 18 : 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0B7C7C) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}

class _ConditionTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color bg;
  final Color iconColor;

  const _ConditionTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.bg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? colorScheme.outline.withOpacity(0.2) : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            height: 74,
            width: 54,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isDark ? colorScheme.onSurface.withOpacity(0.8) : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: colorScheme.onBackground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
