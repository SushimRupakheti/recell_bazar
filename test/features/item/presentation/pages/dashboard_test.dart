import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/presentation/providers/current_user_provider.dart';
import 'package:recell_bazar/features/auth/presentation/state/auth_state.dart';
import 'package:recell_bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:recell_bazar/features/cart/domain/entities/cart_models.dart';
import 'package:recell_bazar/features/cart/presentation/state/cart_state.dart';
import 'package:recell_bazar/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:recell_bazar/features/item/domain/entities/item_entity.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:recell_bazar/features/item/domain/usecases/get_items_by_category_usecase.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard.dart';
import 'package:recell_bazar/features/item/presentation/providers/seller_item_provider.dart';
import 'package:recell_bazar/features/item/presentation/state/item_state.dart';
import 'package:recell_bazar/features/item/presentation/view_model/item_viewmodel.dart';
import 'package:recell_bazar/features/notification/presentation/state/notification_state.dart';
import 'package:recell_bazar/features/notification/presentation/view_model/notification_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockGetAllItemsUsecase extends Mock implements GetAllItemsUsecase {}

class MockGetItemsByCategoryUsecase extends Mock
    implements GetItemsByCategoryUsecase {}

class MockGetItemByIdUsecase extends Mock implements GetItemByIdUsecase {}

class FakeAuthViewModel extends AuthViewModel {
  FakeAuthViewModel(this.initialState);

  final AuthState initialState;

  @override
  AuthState build() => initialState;
}

class FakeCartViewModel extends CartViewModel {
  FakeCartViewModel(this.initialState, this.response, this.onFetch);

  final CartState initialState;
  final CartResponse response;
  final void Function() onFetch;

  @override
  CartState build() => initialState;

  @override
  Future<void> fetchCart() async {
    onFetch();
    state = state.copyWith(status: CartStatus.loaded, cart: response);
  }
}

class FakeItemViewModel extends ItemViewModel {
  FakeItemViewModel(this.initialState);

  final ItemState initialState;

  @override
  ItemState build() => initialState;

  @override
  Future<void> getItemsByUser(String userId) async {
    state = state.copyWith(status: ItemStatus.loaded, items: const []);
  }
}

class FakeNotificationViewModel extends NotificationViewModel {
  FakeNotificationViewModel(this.initialState);

  final NotificationState initialState;
  int fetchCalls = 0;

  @override
  NotificationState build() => initialState;

  @override
  Future<void> fetchNotifications() async {
    fetchCalls++;
    state = state.copyWith(
      status: NotificationStatus.loaded,
      notifications: const [],
      resetErrorMessage: true,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const transparentPngBase64 =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO7ZkYQAAAAASUVORK5CYII=';
    final pngBytes = base64Decode(transparentPngBase64);
    const stringCodec = StringCodec();
    const standardCodec = StandardMessageCodec();
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (message) async {
        final key = stringCodec.decodeMessage(message);
        if (key == null) return null;

        if (key == 'AssetManifest.bin') {
          return standardCodec.encodeMessage(<Object?, Object?>{});
        }

        if (key == 'AssetManifest.json') {
          return ByteData.view(Uint8List.fromList(utf8.encode('{}')).buffer);
        }

        if (key.endsWith('.png')) {
          return ByteData.view(Uint8List.fromList(pngBytes).buffer);
        }

        return null;
      },
    );
    const secureStorageChannel =
        MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async {
          switch (call.method) {
            case 'read':
              return null;
            case 'write':
            case 'delete':
            case 'deleteAll':
              return null;
            case 'readAll':
              return <String, String>{};
            case 'containsKey':
              return false;
            default:
              return null;
          }
        });
  });

  late MockGetAllItemsUsecase mockGetAllItemsUsecase;
  late MockGetItemsByCategoryUsecase mockGetItemsByCategoryUsecase;
  late MockGetItemByIdUsecase mockGetItemByIdUsecase;
  late SharedPreferences prefs;
  late AuthEntity currentUser;
  late AuthState authState;
  late CartState cartState;
  late CartResponse cartResponse;
  late ItemState itemState;
  late NotificationState notificationState;
  int cartFetchCalls = 0;

  Future<void> pumpDashboard(
    WidgetTester tester, {
    List<ItemEntity> sellerItems = const [],
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          currentUserProvider.overrideWithValue(currentUser),
          authViewModelProvider.overrideWith(() => FakeAuthViewModel(authState)),
          cartViewModelProvider.overrideWith(
            () => FakeCartViewModel(
              cartState,
              cartResponse,
              () => cartFetchCalls++,
            ),
          ),
          itemViewModelProvider.overrideWith(() => FakeItemViewModel(itemState)),
          notificationViewModelProvider.overrideWith(
            () => FakeNotificationViewModel(notificationState),
          ),
          sellerItemsProvider.overrideWith((ref, sellerId) async => sellerItems),
          getAllItemsUsecaseProvider.overrideWithValue(mockGetAllItemsUsecase),
          getItemsByCategoryUsecaseProvider.overrideWithValue(
            mockGetItemsByCategoryUsecase,
          ),
          getItemByIdUsecaseProvider.overrideWithValue(mockGetItemByIdUsecase),
        ],
        child: const MaterialApp(home: Dashboard()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'user_id': 'seller-1',
      'user_first_name': 'Test',
      'user_last_name': 'User',
      'user_email': 'test@example.com',
      'user_phone_number': '9800000000',
      'user_address': 'Kathmandu',
    });
    prefs = await SharedPreferences.getInstance();

    currentUser = const AuthEntity(
      authId: 'seller-1',
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      contactNo: '9800000000',
      address: 'Kathmandu',
    );

    mockGetAllItemsUsecase = MockGetAllItemsUsecase();
    mockGetItemsByCategoryUsecase = MockGetItemsByCategoryUsecase();
    mockGetItemByIdUsecase = MockGetItemByIdUsecase();

    when(
      () => mockGetAllItemsUsecase.call(),
    ).thenAnswer((_) async => const Right(<ItemEntity>[]));
    when(
      () => mockGetItemsByCategoryUsecase.call(any()),
    ).thenAnswer((_) async => const Right(<ItemEntity>[]));
    authState = AuthState(
      status: AuthStatus.authenticated,
      user: currentUser,
    );

    cartState = const CartState(status: CartStatus.initial);
    cartResponse = const CartResponse(
      cart: null,
      items: <CartItem>[],
      totalPrice: 0,
    );

    itemState = const ItemState();
    notificationState = const NotificationState();
    cartFetchCalls = 0;
  });

  testWidgets('renders bottom nav with four labels', (tester) async {
    await pumpDashboard(tester);

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Sell'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('shows Home content by default', (tester) async {
    await pumpDashboard(tester);

    expect(find.text('Discover'), findsOneWidget);
  });

  testWidgets('tapping Cart tab shows cart screen', (tester) async {
    await pumpDashboard(tester);
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Your Cart'), findsOneWidget);
  });

  testWidgets('tapping Sell tab shows my listings screen', (tester) async {
    await pumpDashboard(tester);
    await tester.tap(find.text('Sell'));
    await tester.pumpAndSettle();

    expect(find.text('My Listings'), findsOneWidget);
  });

  testWidgets('tapping Profile tab shows profile screen', (tester) async {
    await pumpDashboard(tester);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('can navigate Cart then back to Home', (tester) async {
    await pumpDashboard(tester);
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsOneWidget);
  });

  testWidgets('can navigate Sell then back to Home', (tester) async {
    await pumpDashboard(tester);
    await tester.tap(find.text('Sell'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsOneWidget);
  });

  testWidgets('can navigate Profile then back to Home', (tester) async {
    await pumpDashboard(tester);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsOneWidget);
  });

  testWidgets('bottom nav currentIndex starts at 0', (tester) async {
    await pumpDashboard(tester);

    final nav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(nav.currentIndex, 0);
  });

  testWidgets('bottom nav currentIndex changes to Cart', (tester) async {
    await pumpDashboard(tester);
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    final nav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(nav.currentIndex, 1);
  });

  testWidgets('bottom nav currentIndex changes to Sell', (tester) async {
    await pumpDashboard(tester);
    await tester.tap(find.text('Sell'));
    await tester.pumpAndSettle();

    final nav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(nav.currentIndex, 2);
  });

  testWidgets('bottom nav currentIndex changes to Profile', (tester) async {
    await pumpDashboard(tester);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    final nav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(nav.currentIndex, 3);
  });

  testWidgets('bottom nav is fixed type', (tester) async {
    await pumpDashboard(tester);

    final nav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(nav.type, BottomNavigationBarType.fixed);
  });

  testWidgets('bottom nav shows unselected labels', (tester) async {
    await pumpDashboard(tester);

    final nav = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(nav.showUnselectedLabels, isTrue);
  });

  testWidgets('entering Cart tab triggers cart fetch', (tester) async {
    await pumpDashboard(tester);
    expect(cartFetchCalls, 0);

    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    expect(cartFetchCalls, greaterThanOrEqualTo(1));
  });
}
