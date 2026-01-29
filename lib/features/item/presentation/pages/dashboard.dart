import 'package:flutter/material.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/cart.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/home.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/profile.dart';
import 'package:recell_bazar/features/item/presentation/pages/dashboard_screens/sell.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    Home(),
    Cart(),
    Sell(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
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
