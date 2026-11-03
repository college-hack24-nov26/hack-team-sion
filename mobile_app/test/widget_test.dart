import 'package:flutter_test/flutter_test.dart';
import 'package:rakshan_ai/main.dart';

void main() {
  testWidgets('Rakshan AI boots and displays landing screen matching design', (WidgetTester tester) async {
    await tester.pumpWidget(const RakshanApp());
    await tester.pumpAndSettle();

    expect(find.text('Rakshan'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Block harmful\ncontent'), findsOneWidget);

    // Tap Get Started to ensure flow into Device Setup
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('This is a Parent Device'), findsOneWidget);
    expect(find.text("This is a Child's Phone"), findsOneWidget);
  });
}
