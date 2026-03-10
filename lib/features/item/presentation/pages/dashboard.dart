import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/auth/presentation/state/auth_state.dart';
import 'package:recell_bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:recell_bazar/features/cart/presentation/pages/cart.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/home.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/profile.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/sell.dart';
import 'package:recell_bazar/features/auth/presentation/providers/current_user_provider.dart';
import 'package:recell_bazar/features/item/presentation/providers/seller_item_provider.dart';
import 'package:recell_bazar/l10n/app_localizations.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  int _selectedIndex = 0;


  // NOTE: `ref.listen` must be used inside build for ConsumerState/ConsumerWidget.
  // We'll register the listener in `build` below.
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final homeLabel = l10n?.home ?? 'Home';
    final cartLabel = l10n?.cart ?? 'Cart';
    final sellLabel = l10n?.sell ?? 'Sell';
    final profileLabel = l10n?.profile ?? 'Profile';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedIconColor =
        isDark ? (Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? Colors.white70) : null;

    // listen to auth changes and refresh/invalidate seller cache when needed
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      final prevId = previous?.user?.authId ?? '';
      final nextId = next.user?.authId ?? '';
      if (prevId != nextId) {
        try {
          if (prevId.isNotEmpty) ref.invalidate(sellerItemsProvider(prevId));
        } catch (_) {}
        if (nextId.isNotEmpty) {
          try {
            ref.refresh(sellerItemsProvider(nextId));
            debugPrint('Dashboard: auth changed, refreshed sellerItems for $nextId');
          } catch (_) {}
        }
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final sellerId = authState.user?.authId ?? '';

    final List<Widget> _screens = [
      const Home(),
      const CartPage(),
      SellScreen(sellerId: sellerId),
      const Profile(),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Force-refresh seller items when navigating to Sell tab
          if (index == 2) {
            try {
              if (sellerId.isNotEmpty) {
                ref.refresh(sellerItemsProvider(sellerId));
                debugPrint('Dashboard: refreshed sellerItemsProvider for $sellerId');
              }
            } catch (_) {
              debugPrint('Dashboard: failed to refresh sellerItemsProvider for $sellerId');
            }
          }

          // Force-refresh seller items when navigating to Sell tab
          if (index == 2) {
            final currentUser = ref.read(currentUserProvider);
            final sellerId = currentUser.authId ?? '';
            try {
              ref.refresh(sellerItemsProvider(sellerId));
              debugPrint('Dashboard: refreshed sellerItemsProvider for $sellerId');
            } catch (_) {
              debugPrint('Dashboard: failed to refresh sellerItemsProvider for $sellerId');
            }
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image(
              image: const AssetImage('assets/icons/home.png'),
              height: 35,
              color: unselectedIconColor,
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/home_selected.png'),
              height: 35,
            ),
            label: homeLabel,
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: const AssetImage('assets/icons/cart.png'),
              height: 35,
              color: unselectedIconColor,
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/cart_selected.png'),
              height: 35,
            ),
            label: cartLabel,
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: const AssetImage('assets/icons/sell.png'),
              height: 35,
              color: unselectedIconColor,
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/sell_selected.png'),
              height: 35,
            ),
            label: sellLabel,
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: const AssetImage('assets/icons/profile.png'),
              height: 35,
              color: unselectedIconColor,
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/profile_selected.png'),
              height: 35,
            ),
            label: profileLabel,
          ),
        ],
      ),
    );
  }
}
