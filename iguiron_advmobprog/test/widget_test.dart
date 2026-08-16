// Basic smoke test for the CustomText widget used throughout the app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:iguiron_advmobprog/widgets/custom_text.dart';

void main() {
  testWidgets('CustomText renders the given text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CustomText(text: 'Hello Lab Activity 3')),
      ),
    );

    expect(find.text('Hello Lab Activity 3'), findsOneWidget);
  });
}
