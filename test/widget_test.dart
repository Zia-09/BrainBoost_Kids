import 'package:flutter_test/flutter_test.dart';
import 'package:brainboost_kids/main.dart';

void main() {
  testWidgets('App builds successfully smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BrainBoostKidsApp());

    // Wait for the splash screen or animations to settle
    await tester.pumpAndSettle();
    
    // As long as it pumps without throwing exceptions, the basic app loads fine.
    expect(find.byType(BrainBoostKidsApp), findsOneWidget);
  });
}
