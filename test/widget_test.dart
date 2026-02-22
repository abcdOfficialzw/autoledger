import 'package:flutter_test/flutter_test.dart';
import 'package:motoledger/main.dart';

void main() {
  testWidgets('renders app shell', (WidgetTester tester) async {
    await tester.pumpWidget(const AutoLedgerApp());
    expect(find.text('Add Vehicle'), findsOneWidget);
  });
}
