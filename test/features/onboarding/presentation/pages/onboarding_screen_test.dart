import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recell_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:recell_bazar/features/onboarding/presentation/pages/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen shows first page title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    // Verify first page title & subtitle
    expect(find.text('ReCell Bazar'), findsOneWidget);
    expect(find.text('Your trusted second-hand marketplace'), findsOneWidget);
  });

  testWidgets('Next button goes to second page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    // Tap "Next"
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Check second page content
    expect(find.text('Buy Smarter'), findsOneWidget);
    expect(find.text('Get verified used smartphones at the best price.'), findsOneWidget);
  });
}
