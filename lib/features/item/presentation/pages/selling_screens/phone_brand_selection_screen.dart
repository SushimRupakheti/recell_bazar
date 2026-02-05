import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/second_selling_screen.dart';
import 'package:recell_bazar/features/item/presentation/providers/price_provider.dart';

class PhoneBrandSelectionScreen extends ConsumerWidget {
  PhoneBrandSelectionScreen({super.key});

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

  final Map<String, Map<String, double>> phoneBasePrices = {
    'iPhone': {
      'iPhone 14': 120000,
      'iPhone 14 Pro': 145000,
      'iPhone 13': 95000,
    },
    'Samsung': {
      'Galaxy S23': 110000,
      'Galaxy Note 20': 85000,
      'Galaxy A52': 45000,
    },
    'Poco': {'Poco X5': 35000, 'Poco F4': 55000, 'Poco M4': 30000},
    'Huawei': {'P50': 90000, 'Mate 40': 95000, 'Nova 9': 50000},
    'Pixel': {'Pixel 7': 105000, 'Pixel 6a': 65000},
    'Vivo': {'Vivo V27': 55000, 'Vivo Y33': 32000},
    'Oppo': {'Oppo Reno8': 52000, 'Oppo F21': 38000},
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneData = ref.watch(phonePriceProvider);
    final notifier = ref.read(phonePriceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Phone Brand'),
        backgroundColor: const Color(0xFF0B7C7C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose The Brand Of Your Phone.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: brands.map((brand) {
                final selected = phoneData.category == brand;
                return GestureDetector(
                  onTap: () {
                    notifier.updateField("category", brand);
                    notifier.updateField("phoneModel", '');
                    notifier.updateField(
                        "basePrice",
                        phoneBasePrices[brand]!.values.first); // default first
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 48) / 2,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF0B7C7C)
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
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
                value: phoneData.phoneModel.isEmpty
                    ? null
                    : phoneData.phoneModel,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Select Your Phone\'s Model',
                ),
                items: phoneData.category.isNotEmpty
                    ? phoneModels[phoneData.category]!
                        .map((model) => DropdownMenuItem(
                              value: model,
                              child: Text(model),
                            ))
                        .toList()
                    : [],
                onChanged: (value) {
                  if (value != null) {
                    notifier.updateField("phoneModel", value);
                    notifier.updateField(
                        "basePrice", phoneBasePrices[phoneData.category]![value]!);
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Is Your Phone Factory Unlocked, Officially Registered?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        onPressed: () =>
                            notifier.updateField("factoryUnlock", true),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: phoneData.factoryUnlock
                                  ? const Color(0xFF0B7C7C)
                                  : Colors.grey.shade400,
                              width: 1),
                          backgroundColor: phoneData.factoryUnlock
                              ? const Color(0xFF0B7C7C).withOpacity(0.1)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: phoneData.factoryUnlock
                                ? const Color(0xFF0B7C7C)
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () =>
                            notifier.updateField("factoryUnlock", false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: !phoneData.factoryUnlock
                                  ? const Color(0xFF0B7C7C)
                                  : Colors.grey.shade400,
                              width: 1),
                          backgroundColor: !phoneData.factoryUnlock
                              ? const Color(0xFF0B7C7C).withOpacity(0.1)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: !phoneData.factoryUnlock
                                ? const Color(0xFF0B7C7C)
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'We will not accept any phone that is unlocked or unofficial registration to prevent from anti theft.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 153, 153, 153),
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0B7C7C), width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        color: Color(0xFF0B7C7C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: phoneData.category.isNotEmpty &&
                          phoneData.phoneModel.isNotEmpty &&
                          phoneData.factoryUnlock != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SecondSellingScreen(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B7C7C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
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
