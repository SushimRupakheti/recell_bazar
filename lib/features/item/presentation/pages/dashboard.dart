import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/cart.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/home.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/profile.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/sell.dart';
import 'package:recell_bazar/features/auth/presentation/providers/current_user_provider.dart';
import 'package:recell_bazar/features/item/presentation/providers/seller_item_provider.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final sellerId = currentUser.authId ?? '';

    final List<Widget> _screens = [
      const Home(),
      const Cart(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/icons/home.png'),
              height: 35,
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/home_selected.png'),
              height: 35,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/icons/cart.png'),
              height: 35,
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/cart_selected.png'),
              height: 35,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/icons/sell.png'),
              height: 35,
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/sell_selected.png'),
              height: 35,
            ),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/icons/profile.png'),
              height: 35,
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/profile_selected.png'),
              height: 35,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
