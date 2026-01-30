import 'package:flutter/material.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/phone_brand_selection_screen.dart';

class SellingInfoScreen extends StatelessWidget {
  const SellingInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0C7C8C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Sell"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50),

              /// Top Icon
              Center(
                child: Image.asset(
                  "assets/images/icon123.png",
                  height: 100,
                  width: 100,
                ),
              ),

              const SizedBox(height: 20),

              /// Title
              const Text(
                "Smart Device Valuation",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Montserrat-Bold',
                ),
              ),

              const SizedBox(height: 20),

              /// Subtitle
              const Text(
                "Get a estimated value of your device\nthrough our follow up questions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              /// Steps
              _stepCard(
                step: "1",
                title: "Answer Questions",
                subtitle: "Tell Us About Your Device’s Condition",
              ),

              _stepCard(
                step: "2",
                title: "Sensor Diagnostics",
                subtitle: "Sensor Functionality Check",
              ),

              _stepCard(
                step: "3",
                title: "Get Confirmation",
                subtitle: "Receive Appointment Token",
              ),

              const SizedBox(height: 20),

              /// Info text
              const Text(
                "Make sure you have entered correct information about your device. "
                "Final price deal will only be discussed in physical store.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B7C7C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneBrandSelectionScreen(),
                            ),
                          );
                  },
                  child: const Text(
                    "Start Valuation",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _stepCard({
    required String step,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF00D6D6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
