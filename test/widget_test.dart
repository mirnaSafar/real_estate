import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate/main.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We skip extensive widget tree verification for now since the app 
    // depends on complex Supabase initialization.
    await tester.pumpWidget(ClientRealEstateApp());
    
    // Simplest possible check: the app should exist
    expect(find.byType(ClientRealEstateApp), findsOneWidget);
  });
}
