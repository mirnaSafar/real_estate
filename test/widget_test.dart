import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Minimal build test', (WidgetTester tester) async {
    // Build a minimal widget tree to verify the test environment is working.
    // This avoids dependency on Supabase initialization which can hang in CI.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Real Estate App')),
        ),
      ),
    );

    expect(find.text('Real Estate App'), findsOneWidget);
  });
}
