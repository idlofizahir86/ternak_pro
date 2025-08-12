import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ternak_pro/ui_pages/splash_page.dart';
import 'package:ternak_pro/shared/theme.dart';
import 'package:ternak_pro/ui_pages/onboarding/onboarding_1.dart';

void main() {
  // Mock SharedPreferences
  setUp(() {
    SharedPreferences.setMockInitialValues({'hasSeenBanner': true});
  });

  testWidgets('SplashPage displays logo image and gradient background', (WidgetTester tester) async {
    // Build SplashPage with Navigator and ThemeData
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgLight),
        ),
        home: const SplashPage(),
      ),
    );

    // Verify initial widgets
    expect(
      find.byKey(const ValueKey('splash_logo')),
      findsOneWidget,
      reason: 'Failed to find Image widget with ValueKey "splash_logo"',
    );

    expect(
      find.byType(Image),
      findsOneWidget,
      reason: 'Failed to find any Image widget',
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).gradient != null,
      ),
      findsOneWidget,
      reason: 'Failed to find Container with gradient background',
    );

    // Fast-forward time by 3 seconds and pump frames
    await tester.pump(const Duration(seconds: 3));
    
    // Wait for navigation to complete
    await tester.pumpAndSettle();

    // Verify the navigation to Onboarding1 page
    expect(find.byType(Onboarding1), findsOneWidget, reason: 'Failed to navigate to Onboarding1');
  });
}
