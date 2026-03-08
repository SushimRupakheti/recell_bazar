import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/presentation/state/auth_state.dart';
import 'package:recell_bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:recell_bazar/features/cart/domain/entities/cart_models.dart';
import 'package:recell_bazar/features/cart/presentation/state/cart_state.dart';
import 'package:recell_bazar/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/profile.dart';
import 'package:recell_bazar/features/item/presentation/providers/seller_item_provider.dart';
import 'package:recell_bazar/features/item/presentation/state/item_state.dart';
import 'package:recell_bazar/features/item/presentation/view_model/item_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthViewModel extends AuthViewModel {
  FakeAuthViewModel(this.initialState, this.onLogout);

  final AuthState initialState;
  final void Function() onLogout;

  @override
  AuthState build() => initialState;

  @override
  Future<void> logout() async {
    onLogout();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
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

class FakeCartViewModel extends CartViewModel {
  FakeCartViewModel(this.initialState, this.response);

  final CartState initialState;
  final CartResponse response;

  @override
  CartState build() => initialState;

  @override
  Future<void> fetchCart() async {
    state = state.copyWith(status: CartStatus.loaded, cart: response);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
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

  late SharedPreferences prefs;
  late AuthEntity user;
  late ItemState itemState;
  late CartState cartState;
  int logoutCalls = 0;

  Future<void> pumpProfile(
    WidgetTester tester, {
    required AuthState authState,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authViewModelProvider.overrideWith(
            () => FakeAuthViewModel(authState, () => logoutCalls++),
          ),
          itemViewModelProvider.overrideWith(() => FakeItemViewModel(itemState)),
          cartViewModelProvider.overrideWith(
            () => FakeCartViewModel(
              cartState,
              const CartResponse(cart: null, items: <CartItem>[], totalPrice: 0),
            ),
          ),
          sellerItemsProvider.overrideWith((ref, sellerId) async => const []),
        ],
        child: const MaterialApp(home: Profile()),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'user_id': 'u-1',
      'user_first_name': 'Test',
      'user_last_name': 'User',
      'user_email': 'test@example.com',
      'user_phone_number': '9800000000',
      'user_address': 'Kathmandu',
    });
    prefs = await SharedPreferences.getInstance();

    user = const AuthEntity(
      authId: 'u-1',
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      contactNo: '9800000000',
      address: 'Kathmandu',
    );
    itemState = const ItemState();
    cartState = const CartState(status: CartStatus.initial);
    logoutCalls = 0;
  });

  testWidgets('renders main profile sections', (tester) async {
    await pumpProfile(
      tester,
      authState: AuthState(status: AuthStatus.authenticated, user: user),
    );

    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Support & About'), findsOneWidget);
  });

  testWidgets('shows profile header user name from session', (tester) async {
    await pumpProfile(
      tester,
      authState: AuthState(status: AuthStatus.authenticated, user: user),
    );

    expect(find.text('Test User'), findsOneWidget);
  });

  testWidgets('shows stats card labels', (tester) async {
    await pumpProfile(
      tester,
      authState: AuthState(status: AuthStatus.authenticated, user: user),
    );

    expect(find.text('Sold'), findsOneWidget);
    expect(find.text('Listed'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
  });

  testWidgets('shows fingerprint register action by default', (tester) async {
    await pumpProfile(
      tester,
      authState: AuthState(status: AuthStatus.authenticated, user: user),
    );

    expect(find.text('Register fingerprint'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
  });

  testWidgets('tapping logout calls viewmodel logout', (tester) async {
    await pumpProfile(
      tester,
      authState: AuthState(status: AuthStatus.authenticated, user: user),
    );

    await tester.scrollUntilVisible(
      find.widgetWithText(OutlinedButton, 'Log out'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Log out'));
    await tester.pump();

    expect(logoutCalls, 1);
  });

  testWidgets('shows loading logout label and disables button', (tester) async {
    await pumpProfile(
      tester,
      authState: AuthState(status: AuthStatus.loading, user: user),
    );

    expect(find.text('Logging out...'), findsOneWidget);
    final btn = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(btn.onPressed, isNull);
  });
}
