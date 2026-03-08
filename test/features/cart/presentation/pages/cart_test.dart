import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/features/cart/data/repositories/cart_repository.dart';
import 'package:recell_bazar/features/cart/domain/entities/cart_models.dart';
import 'package:recell_bazar/features/cart/domain/repositories/cart_repository.dart';
import 'package:recell_bazar/features/cart/presentation/pages/cart.dart';

class FakeCartRepository implements ICartRepository {
  FakeCartRepository({
    required this.onFetchCart,
  });

  Future<Either<Failure, CartResponse>> Function() onFetchCart;
  int fetchCalls = 0;

  @override
  Future<Either<Failure, bool>> addToCart(String productId) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, CartResponse>> fetchCart() async {
    fetchCalls++;
    return onFetchCart();
  }

  @override
  Future<Either<Failure, bool>> removeCartItem(String cartItemId) async {
    return const Right(true);
  }
}

void main() {
  Widget buildTestApp(FakeCartRepository fakeRepo) {
    return ProviderScope(
      overrides: [
        cartRepositoryProvider.overrideWithValue(fakeRepo),
      ],
      child: const MaterialApp(
        home: CartPage(),
      ),
    );
  }

  CartResponse buildCartResponse({
    required List<CartItem> items,
    required double totalPrice,
  }) {
    return CartResponse(
      cart: const CartMeta(id: 'cart-1', userId: 'user-1'),
      items: items,
      totalPrice: totalPrice,
    );
  }

  CartItem buildCartItem({
    required String id,
    required String model,
    required String category,
    required double price,
  }) {
    return CartItem(
      id: id,
      cartId: 'cart-1',
      productId: CartProductSnapshot(
        id: 'product-$id',
        phoneModel: model,
        category: category,
        finalPrice: price.toString(),
        basePrice: (price * 1.2).toString(),
        photos: const <String>[],
        isSold: false,
        status: 'approved',
        description: 'Item description',
      ),
      priceAtTime: price,
    );
  }

  testWidgets('shows loading indicator while cart is being fetched', (
    tester,
  ) async {
    final completer = Completer<Either<Failure, CartResponse>>();
    final fakeRepo = FakeCartRepository(
      onFetchCart: () => completer.future,
    );

    await tester.pumpWidget(buildTestApp(fakeRepo));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state when cart has no items', (tester) async {
    final fakeRepo = FakeCartRepository(
      onFetchCart: () async => Right(
        buildCartResponse(items: const <CartItem>[], totalPrice: 0),
      ),
    );

    await tester.pumpWidget(buildTestApp(fakeRepo));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Add items to see them here.'), findsOneWidget);
  });

  testWidgets('shows error state with retry button when fetch fails', (
    tester,
  ) async {
    final fakeRepo = FakeCartRepository(
      onFetchCart: () async => const Left(
        ApiFailure(message: 'Failed to load cart'),
      ),
    );

    await tester.pumpWidget(buildTestApp(fakeRepo));
    await tester.pumpAndSettle();

    expect(find.text('Failed to load cart'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);
  });

  testWidgets('tapping retry triggers fetchCart again', (tester) async {
    final fakeRepo = FakeCartRepository(
      onFetchCart: () async => const Left(ApiFailure(message: 'Network down')),
    );

    await tester.pumpWidget(buildTestApp(fakeRepo));
    await tester.pumpAndSettle();

    expect(fakeRepo.fetchCalls, 1);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
    await tester.pumpAndSettle();

    expect(fakeRepo.fetchCalls, 2);
  });

  testWidgets('shows loaded cart items and formatted total', (tester) async {
    final items = <CartItem>[
      buildCartItem(
        id: '1',
        model: 'iPhone 13',
        category: 'Apple',
        price: 1500,
      ),
      buildCartItem(
        id: '2',
        model: 'Pixel 8',
        category: 'Google',
        price: 1500.5,
      ),
    ];

    final fakeRepo = FakeCartRepository(
      onFetchCart: () async => Right(
        buildCartResponse(items: items, totalPrice: 3000.5),
      ),
    );

    await tester.pumpWidget(buildTestApp(fakeRepo));
    await tester.pumpAndSettle();

    expect(find.text('iPhone 13'), findsOneWidget);
    expect(find.text('Pixel 8'), findsOneWidget);
    expect(find.text('NPR 1500'), findsOneWidget);
    expect(find.text('NPR 1500.50'), findsOneWidget);
    expect(find.text('2 items'), findsOneWidget);
    expect(find.text('NPR 3000.50'), findsOneWidget);
  });
}
