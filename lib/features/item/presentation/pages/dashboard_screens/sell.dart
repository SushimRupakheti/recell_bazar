import 'package:flutter/material.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/phone_brand_selection_screen.dart';

class Sell extends StatelessWidget {
  const Sell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar optional
      appBar: AppBar(
        title: const Text('Sell'),
        backgroundColor: Colors.teal,
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
              builder: (context) =>  PhoneBrandSelectionScreen(),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
