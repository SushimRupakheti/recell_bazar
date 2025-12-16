import 'package:flutter/material.dart';
import 'package:recell_bazar/models/offer_model.dart';
import 'package:recell_bazar/models/product_model.dart';
import 'package:recell_bazar/widgets/custom_choice_chip.dart';
import 'package:recell_bazar/widgets/offer_card.dart';
import 'package:recell_bazar/widgets/product_card.dart';
import 'package:recell_bazar/widgets/topbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Product> products = [
  Product(
    id: '1',
    name: 'Samsung Galaxy S23',
    category: 'Samsung',
    price: 120000,
    rating: 4.5,
    storage: 256,
    imageUrl: 'assets/images/bg.png',
  ),
];

  final List<Offer> offers = [
    Offer(
      tag: '#brandsweek',
      discount: '50% off',
      title: 'On all Samsung Phones',
    ),
    Offer(tag: '#summerdeal', discount: '30% off', title: 'On all iPhones'),
    Offer(tag: '#flashsale', discount: '20% off', title: 'On Vivo Phones'),
  ];
  final _gap = SizedBox(height: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _gap,

            Topbar(),

            _gap,

            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: CustomChoiceChip(),
            ),

            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: OfferCard(offer: offers[index], activeIndex: index),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Discover",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B7C7C),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: products[index],
                    onTap: () {
                      // navigate to detail page
                    },
                    onFavoriteTap: () {
                      // toggle favorite
                    },
                  );
                },
              ),
            ), // 🔚 End of Expanded (Product Grid Section)
          ],
        ),
      ),
    );
  }
}
