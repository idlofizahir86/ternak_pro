import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ternak_pro/ui_pages/login/login_page.dart';
import 'package:ternak_pro/shared/theme.dart';
import 'package:ternak_pro/shared/widgets/login_app_textfield.dart';

void main() {
  testWidgets('LoginPage displays UI elements', (WidgetTester tester) async {
    // Build LoginPage with ThemeData
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgLight),
        ),
        home: const LoginPage(),
      ),
    );

    // Wait for rendering
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Debug widget tree if needed
    // debugDumpApp();

    // Verify title text
    expect(
      find.text('Masuk Ke\nAkun Kamu'),
      findsOneWidget,
      reason: 'Failed to find title text "Masuk Ke\nAkun Kamu"',
    );

    // Verify subtitle text
    expect(
      find.text('Masukkan email dan password kamu untuk Login'),
      findsOneWidget,
      reason: 'Failed to find subtitle text',
    );

    // Verify text fields
    expect(
      find.byType(LoginAppTextfield),
      findsNWidgets(2),
      reason: 'Failed to find two LoginAppTextfield widgets',
    );

    // Verify Google button text
    expect(
      find.text('Masuk Dengan Google'),
      findsOneWidget,
      reason: 'Failed to find "Masuk Dengan Google" text',
    );

    // Verify login button text
    expect(
      find.byKey(const ValueKey('login_button_text')),
      findsOneWidget,
      reason: 'Failed to find "Masuk" button text with ValueKey',
    );

    // Verify other UI elements
    expect(
      find.text('Ingat Saya'),
      findsOneWidget,
      reason: 'Failed to find "Ingat Saya" text',
    );

    expect(
      find.text('Lupa Password ?'),
      findsOneWidget,
      reason: 'Failed to find "Lupa Password ?" text',
    );

    expect(
      find.text('Belum punya akun ?'),
      findsOneWidget,
      reason: 'Failed to find "Belum punya akun ?" text',
    );

    expect(
      find.text('Daftar'),
      findsOneWidget,
      reason: 'Failed to find "Daftar" text',
    );
  });

  testWidgets('LoginPage handles valid login', (WidgetTester tester) async {
    // Build LoginPage with routes
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgLight),
        ),
        routes: {
          '/main': (context) => const Scaffold(body: Text('Main Page')),
        },
        home: const LoginPage(),
      ),
    );

    // Wait for rendering
    await tester.pumpAndSettle();

    // Enter valid email and password
    await tester.enterText(find.byType(LoginAppTextfield).at(0), 'test@example.com');
    await tester.enterText(find.byType(LoginAppTextfield).at(1), 'password123');
    await tester.pump();

    // Tap the login button
    await tester.tap(
      find.descendant(
        of: find.byType(ElevatedButton),
        matching: find.byKey(const ValueKey('login_button_text')),
      ),
    );
    await tester.pumpAndSettle();

    // Verify navigation to /main
    expect(
      find.text('Main Page'),
      findsOneWidget,
      reason: 'Failed to navigate to Main Page',
    );
  });
}