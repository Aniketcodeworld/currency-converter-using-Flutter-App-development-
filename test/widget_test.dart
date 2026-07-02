import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_converter/main.dart';

void main() {
  testWidgets('converts USD to INR', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Currency Calculator'), findsOneWidget);
    expect(find.text('83 INR'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '2');
    await tester.pump();

    expect(find.text('166 INR'), findsOneWidget);
  });
}
