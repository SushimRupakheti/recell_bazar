import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return const CartProduct();
      },
    );
  }
}

class CartProduct extends StatelessWidget {
  const CartProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 238, 238),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/bg.png',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Iphone',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 88, 88, 88),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Iphone 15 Pro Max',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.star, size: 14, color: Colors.black),
                    SizedBox(width: 4),
                    Text(
                      '4.5',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(width: 24),
                    Text(
                      '256 GB',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.more_vert, size: 20),
              const SizedBox(height: 30),
              const Text(
                'NPR 156,000',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
