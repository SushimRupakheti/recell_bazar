import 'package:flutter/material.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/second_selling_screen.dart';

class PhoneBrandSelectionScreen extends StatefulWidget {
  @override
  _PhoneBrandSelectionScreenState createState() =>
      _PhoneBrandSelectionScreenState();
}

class _PhoneBrandSelectionScreenState extends State<PhoneBrandSelectionScreen> {
  String? selectedBrand;
  String? selectedModel;
  bool? isUnlocked;

  final List<String> brands = [
    'iPhone',
    'Samsung',
    'Poco',
    'Huawei',
    'Pixel',
    'Vivo',
    'Oppo',
  ];

  final Map<String, List<String>> phoneModels = {
    'iPhone': ['iPhone 14', 'iPhone 14 Pro', 'iPhone 13'],
    'Samsung': ['Galaxy S23', 'Galaxy Note 20', 'Galaxy A52'],
    'Poco': ['Poco X5', 'Poco F4', 'Poco M4'],
    'Huawei': ['P50', 'Mate 40', 'Nova 9'],
    'Pixel': ['Pixel 7', 'Pixel 6a'],
    'Vivo': ['Vivo V27', 'Vivo Y33'],
    'Oppo': ['Oppo Reno8', 'Oppo F21'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Phone Brand'),
        backgroundColor: Colors.teal,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose The Brand Of Your Phone.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: brands.map((brand) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBrand = brand;
                      selectedModel = null;
                    });
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 48) / 2,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedBrand == brand
                            ? Colors.teal
                            : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/${brand.toLowerCase()}.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
                value: selectedModel,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Select Your Phone\'s Model',
                ),
                items: selectedBrand != null
                    ? phoneModels[selectedBrand]!
                          .map(
                            (model) => DropdownMenuItem(
                              value: model,
                              child: Text(model),
                            ),
                          )
                          .toList()
                    : [],
                onChanged: (value) {
                  setState(() {
                    selectedModel = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),

            // Center the question and radio buttons
            Center(
              child: Column(
                children: [
                  Text(
                    'Is Your Phone Factory Unlocked, Officially Registered?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Yes Button
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isUnlocked = true;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isUnlocked == true
                                ? Colors.teal
                                : const Color.fromARGB(255, 207, 207, 207),
                            width: 1,
                          ),
                          backgroundColor: isUnlocked == true
                              ? Colors.teal.withOpacity(0.1)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: isUnlocked == true
                                ? Colors.teal
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),

                      // No Button
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isUnlocked = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isUnlocked == true
                                ? Colors.teal
                                : const Color.fromARGB(255, 207, 207, 207),
                            width: 1,
                          ),
                          backgroundColor: isUnlocked == false
                              ? Colors.teal.withOpacity(0.1)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: isUnlocked == false
                                ? Colors.teal
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'We will not accept any phone that is unlocked or unofficial registration to prevent from anti theft.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 153, 153, 153),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.teal, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  onPressed:
                      selectedBrand != null &&
                          selectedModel != null &&
                          isUnlocked != null
                      ? () {
                          // Handle next step
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SecondSellingScreen(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
