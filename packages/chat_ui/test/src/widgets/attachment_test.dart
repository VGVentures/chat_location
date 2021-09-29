// ignore_for_file: prefer_const_constructors

import 'package:chat_ui/chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Attachment', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        Attachment(
          child: FlutterLogo(),
        ),
      );
      expect(find.byType(Attachment), findsOneWidget);
    });
  });
}
