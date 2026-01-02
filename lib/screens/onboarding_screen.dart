import 'package:flutter/material.dart';
import 'package:recell_bazar/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/logo.png",
      "title": "ReCell Bazar",
      "subtitle": "Your trusted second-hand marketplace",
    },
    {
      "image": "assets/images/buy.png",
      "title": "Buy Smarter",
      "subtitle": "Get verified used smartphones at the best price.",
    },
    {
      "image": "assets/images/sell.png",
      "title": "Sell Faster",
      "subtitle": "Post your device and reach thousands instantly.",
    },
  ];

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Go to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // Skip Button (Top Right)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Skip",style: TextStyle(
                  fontFamily: "Montserrat-SemiBold",
                ),),
              ),
            ),

            // PageView Section
            Expanded(
              flex: 4,
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        pages[index]["image"]!,
                        height: 450,
                      ),


                      Text(
                        pages[index]["title"]!,
                        style: const TextStyle(
                          fontSize: 32,
                          fontFamily: "Montserrat-Bold",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B7C7C),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          pages[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Page Indicator (Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 10,
                  width: currentIndex == index ? 22 : 10,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? const Color(0xFF0B7C7C)
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Next / Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B7C7C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    currentIndex == pages.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
