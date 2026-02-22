import 'package:flutter/material.dart';
import 'package:recell_bazar/core/widgets/cart_product.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
