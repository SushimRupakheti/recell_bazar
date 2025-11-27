import 'package:flutter/material.dart';
import 'package:recell_bazar/resubales/custom_choice_chip.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12), // cleaner
              child: Row(
                children: [

                  Flexible(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        // labelText: "Search",
                        hintText: 'Search..',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),
                  Icon(Icons.tune,color: Color(0xFF0B7C7C),size: 30,),
                  SizedBox(width: 8),
                  Icon(Icons.notifications,color: Color(0xFF0B7C7C),size:30),
                ],
              ),
            ),
SizedBox(height: 12),

Padding(
  padding: const EdgeInsets.all(5.0),
  child: CustomChoiceChip(),
),

          ],
        ),
      ),
    );
  }
}
