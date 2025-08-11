import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ternak_pro/ui_pages/splash_page.dart';
import 'package:ternak_pro/shared/theme.dart';
import 'package:fake_async/fake_async.dart';
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

    // Use fake_async to control the timer
    await fakeAsync((async) async {
      // Simulate the 3-second timer
      async.elapse(const Duration(seconds: 3));

      // Wait for the widget tree to settle (including animations)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    // Verify the logo with ValueKey
    expect(
      find.byKey(const ValueKey('splash_logo')),
      findsOneWidget,
      reason: 'Failed to find Image widget with ValueKey "splash_logo"',
    );

    // Verify at least one Image widget exists
    expect(
      find.byType(Image),
      findsOneWidget,
      reason: 'Failed to find any Image widget',
    );

    // Verify the gradient background in a Container widget
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

    // Verify the navigation to Onboarding1 page
    expect(find.byType(Onboarding1), findsOneWidget, reason: 'Failed to navigate to Onboarding1');
  });
}
