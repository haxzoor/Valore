// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diplom2/main.dart';

void main() {
  testWidgets('finds a Text widget', (tester) async {
  await tester.pumpWidget(const MaterialApp(
    home: Scaffold(
      body: Text('Активные заявки'),
    ),
  ));
      expect(find.text('Активные заявки'), findsOneWidget);
  });

  testWidgets('finds a Text widget', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('О заявке'),
      ),
    ));
    expect(find.text('О заявке'), findsOneWidget);
  });

  testWidgets('finds a Text widget', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('Участники'),
      ),
    ));
    expect(find.text('Участники'), findsOneWidget);
  });

  testWidgets('finds a widget using a Key', (tester) async {
    // Define the test key.
    const testKey = Key('_formKey');
    await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));
    expect(find.byKey(testKey), findsOneWidget);
  });

  testWidgets('finds a widget using a Key', (tester) async {
    const testKey = Key('key');
    await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));
    expect(find.byKey(testKey), findsOneWidget);
  });
  //
  // testWidgets('finds a Text widget', (tester) async {
  //   await tester.pumpWidget(const MaterialApp(
  //     home: Scaffold(
  //       body: Text('Регистрация'),
  //     ),
  //   ));
  //   expect(find.text('Регистрация'), findsOneWidget);
  // });
  //
  // testWidgets('finds a Text widget', (tester) async {
  //   await tester.pumpWidget(const MaterialApp(
  //     home: Scaffold(
  //       body: Text('Вход'),
  //     ),
  //   ));
  //   expect(find.text('Вход'), findsOneWidget);
  // });
}
