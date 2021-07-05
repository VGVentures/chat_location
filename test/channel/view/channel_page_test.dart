import 'package:chat_location/channel/channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ChannelPage', () {
    testWidgets('renders a Scaffold', (tester) async {
      await tester.pumpApp(const ChannelPage());
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
