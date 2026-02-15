import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search..',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // SizedBox(width: 8),
                  // Icon(Icons.tune, color: Color(0xFF0B7C7C), size: 30),
                  SizedBox(width: 12),
                  Icon(Icons.notifications, color: Color(0xFF0B7C7C), size: 30),
                ],
              ),
            );
  }
}