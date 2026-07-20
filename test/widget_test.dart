import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_ticket_app/main.dart';
import 'package:memory_ticket_app/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  testWidgets('App starts with OnboardingPage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(initialHome: OnboardingPage()));

    // Verify that OnboardingPage is shown by looking for the title
    expect(find.text('Memory Ticket'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });
}
