import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App login test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    // Verify that the login page is shown
    expect(find.text('Welcome Back'), findsOneWidget);

    // Tap the 'Sign In' button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the home page is shown
    expect(find.text('Home'), findsOneWidget);
  });
}
