import 'package:chat_location/channel/channel.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockChannel extends Mock implements Channel {}

void main() {
  group('ChannelPage', () {
    late Channel channel;

    setUp(() {
      channel = MockChannel();
    });

    testWidgets('renders a Scaffold', (tester) async {
      await tester.pumpApp(ChannelPage(channel: channel));
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
