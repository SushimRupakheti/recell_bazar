import 'package:flutter/material.dart';
import 'package:recell_bazar/widgets/cart_product.dart';
import 'package:recell_bazar/widgets/topbar.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Topbar(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CartProduct(),
            ),   
          ],
        ),
      ),
    );
  }
}