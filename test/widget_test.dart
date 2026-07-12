import 'package:flutter_test/flutter_test.dart';
import 'package:ora/main.dart';

void main() {
  testWidgets('Ora app shows splash', (WidgetTester tester) async {
    await tester.pumpWidget(const OraApp());
    await tester.pump();
    expect(find.text('Ora'), findsOneWidget);
  });
}
