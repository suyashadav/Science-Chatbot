import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:science_chatbot/main.dart';

void main() {
  testWidgets('IntroScreen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const ChatBotApp());

    // Verify these elements exist on the intro screen
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Your future is bright.'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Skip button navigates to WelcomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const ChatBotApp());
    
    // Verify WelcomeScreen isn't shown initially
    expect(find.text('Boot your confidence'), findsNothing);
    
    // Tap the Skip button
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();  // Wait for navigation animation
    
    // Verify WelcomeScreen appears
    expect(find.text('Boot your confidence'), findsOneWidget);
  });
}