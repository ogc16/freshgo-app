import 'package:flutter_test/flutter_test.dart';
import 'package:freshgo_app/main.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodApp());
    expect(find.text('FoodApp'), findsOneWidget);
  });
}
