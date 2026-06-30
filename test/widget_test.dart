import 'package:flutter_test/flutter_test.dart';
import 'package:anas_portfolio/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const AnasPortfolioApp());
    expect(find.text("Hi, I'm Anas"), findsOneWidget);
  });
}
