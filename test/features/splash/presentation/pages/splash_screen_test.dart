import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/splash/presentation/pages/splash_screen.dart';


void main() {
  testWidgets("SplashScreen should show app name text",
      (WidgetTester tester) async {
    // Arrange: Pump SplashScreen inside ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    // Act: Find the text widget
    Finder titleText = find.text("ReCell \n Bazar");

    // Assert: Expect it exists
    expect(titleText, findsOneWidget);
  });
}
