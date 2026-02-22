import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/cart/presentation/providers/cart_provider.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:uuid/uuid.dart';
import 'package:recell_bazar/features/payment/presentation/providers/payment_provider.dart';
import 'package:recell_bazar/features/payment/domain/entities/payment_request.dart';

class SingleItemScreen extends ConsumerStatefulWidget {
  final ItemEntity item;

  const SingleItemScreen({super.key, required this.item});

  @override
  ConsumerState<SingleItemScreen> createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends ConsumerState<SingleItemScreen> {
  final PageController _pageController = PageController();
  int _activeIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showBookingSheet() {
    final userSession = ref.read(userSessionServiceProvider);
    final defaultFirst = userSession.getFirstName() ?? '';
    final defaultLast = userSession.getUserLastName() ?? '';
    final defaultFullName = (defaultFirst + ' ' + defaultLast).trim();
    final defaultEmail = userSession.getUserEmail() ?? '';
    final defaultPhone = userSession.getUserPhoneNumber() ?? '';
    final defaultAddress = userSession.getUserAddress() ?? '';

    final priceInt = int.tryParse(widget.item.finalPrice.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final locationCtrl = TextEditingController(text: defaultAddress);
    final dateCtrl = TextEditingController(text: DateTime.now().toIso8601String().split('T').first);
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
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Answer The Questions Below:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),

                  // Shop
                  const Text('Shop:', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: locationCtrl,
                    decoration: InputDecoration(labelText: 'Location', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: dateCtrl,
                        readOnly: true,
                        decoration: InputDecoration(labelText: 'Date', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
                        onTap: () async {
                          final dt = await showDatePicker(context: ctx, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
                          if (dt != null) dateCtrl.text = dt.toIso8601String().split('T').first;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: timeCtrl,
                        readOnly: true,
                        decoration: InputDecoration(labelText: 'Time', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
                        onTap: () async {
                          final t = await showTimePicker(context: ctx, initialTime: const TimeOfDay(hour: 16, minute: 0));
                          if (t != null) timeCtrl.text = t.format(ctx);
                        },
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),
                  const Text('Seller Info:', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(controller: fullNameCtrl, decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)))),
                  const SizedBox(height: 8),
                  TextField(controller: numberCtrl, decoration: InputDecoration(labelText: 'Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)))),
                  const SizedBox(height: 8),
                  TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)))),
                  const SizedBox(height: 8),
                  TextField(controller: phoneModelCtrl, decoration: InputDecoration(labelText: 'Phone Model', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)))),
                  const SizedBox(height: 8),
                  TextField(controller: priceCtrl, decoration: InputDecoration(labelText: 'Price', border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)))),

                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B7C7C)),
                        onPressed: () async {
                          final enteredEmail = emailCtrl.text.trim();
                          if (enteredEmail.isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter an email address')));
                            return;
                          }
                          await _submitBooking(
                            location: locationCtrl.text,
                            date: dateCtrl.text,
                            time: timeCtrl.text,
                            fullName: fullNameCtrl.text,
                            number: numberCtrl.text,
                            email: enteredEmail,
                            phoneModel: phoneModelCtrl.text,
                            price: int.tryParse(priceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? priceInt,
                          );
                          Navigator.of(ctx).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Finish', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
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
    final id = 'BK-${DateTime.now().millisecondsSinceEpoch}-${Uuid().v4().substring(0, 6)}';

    final request = PaymentRequest(
      amount: price,
      productName: widget.item.phoneModel,
      productId: widget.item.itemId ?? '',
      buyerName: fullName,
      buyerEmail: email,
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
  }

  Future<void> _showStripeConfigDialog(String details) async {
    // Configuration dialog moved to payment provider. No-op kept for compatibility.
    return;
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.item.photos;
    final hasPhotos = photos.isNotEmpty;

    // You can replace these with real fields from ItemEntity if you have them
    final rating = 4.5;
    final storageText = "256 GB";

    return Scaffold(
      backgroundColor: Colors.white,
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
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: hasPhotos
                            ? PageView.builder(
                                controller: _pageController,
                                itemCount: photos.length,
                                onPageChanged: (i) => setState(() => _activeIndex = i),
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
                                child: Icon(Icons.image, size: 64, color: Colors.grey),
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
                  ],
                ),
              ),

              // ===== DOT INDICATOR =====
              if (hasPhotos) ...[
                const SizedBox(height: 10),
                Center(child: _Dots(count: photos.length, active: _activeIndex)),
              ] else ...[
                const SizedBox(height: 10),
                Center(child: _Dots(count: 5, active: 0)), // screenshot-like placeholder
              ],

              const SizedBox(height: 14),

              // ===== SMALL BRAND LABEL =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Iphone",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
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
                        widget.item.phoneModel.isNotEmpty ? widget.item.phoneModel : "Item",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "NPR${widget.item.finalPrice}",
                      style: const TextStyle(
                        color: Color(0xFF0B7C7C),
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
                    const Icon(Icons.star, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      storageText,
                      style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    ),
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
                      value: widget.item.cameraCondition ? "Need Replacement":"Excellent",
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
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.item.description.isNotEmpty
                          ? widget.item.description
                          : "No description available.",
                      style: TextStyle(color: Colors.grey.shade800, height: 1.35),
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
                      widget.item.year.toString(),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, -4),
            )
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B7C7C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    onPressed: () => _showBookingSheet(),
                    child: const Text(
                      "Book Now",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 140,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // add to cart via provider
                      ref.read(cartProvider.notifier).addItem(widget.item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
                    child: const Text('Add to Cart', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
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
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
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
