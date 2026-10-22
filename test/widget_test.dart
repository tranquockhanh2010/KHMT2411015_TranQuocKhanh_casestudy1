// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:andev/main.dart';
import 'package:andev/screens/filter_screen.dart';
import 'package:andev/screens/profile_screen.dart';
import 'package:andev/screens/statistics_screen.dart';
import 'package:andev/screens/transactions_screen.dart';

void main() {
  testWidgets('opens expense page from dashboard add button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExpenseManagerApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Thêm giao dịch'), findsOneWidget);
  });

  testWidgets('renders the missing application screens', (
    WidgetTester tester,
  ) async {
    for (final screen in const [
      TransactionsScreen(),
      StatisticsScreen(),
      ProfileScreen(),
      FilterScreen(),
    ]) {
      await tester.pumpWidget(MaterialApp(home: screen));
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    }
  });
}
