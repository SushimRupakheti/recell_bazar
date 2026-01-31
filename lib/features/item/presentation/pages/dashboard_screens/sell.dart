import 'package:flutter/material.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/selling_info_screen.dart';

class Sell extends StatelessWidget {
  const Sell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar optional
      appBar: AppBar(
        title: const Text('Sell'),
        backgroundColor: Color(0xFF0B7C7C),
      ),
      body: const Center(
        child: Text(
          'Tap the + button to sell a phone',
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to PhoneBrandSelectionScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  SellingInfoScreen(),
            ),
          );
        },
        backgroundColor: Color(0xFF0B7C7C),
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
