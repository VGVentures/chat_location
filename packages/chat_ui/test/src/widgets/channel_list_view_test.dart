import 'package:chat_ui/chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as stream_chat_flutter;

class MockStreamChatClient extends Mock
    implements stream_chat_flutter.StreamChatClient {}

class MockChannel extends Mock implements stream_chat_flutter.Channel {}

void main() {
  group('ChannelListView', () {
    late stream_chat_flutter.StreamChatClient client;

    setUp(() {
      client = MockStreamChatClient();
      when(() => client.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders ChannelListView with correct configuration',
        (tester) async {
      const userId = 'test-user-id';
      await tester.pumpWidget(
        MaterialApp(
          home: stream_chat_flutter.StreamChat(
            client: client,
            child: Material(
              child: ChannelListView(
                userId: userId,
                channelBuilder: (context, channel) => const SizedBox(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(stream_chat_flutter.ChannelsBloc), findsOneWidget);
      final channelsListViewFinder =
          find.byType(stream_chat_flutter.ChannelListView);
      final channelsListView = tester
          .widget<stream_chat_flutter.ChannelListView>(channelsListViewFinder);
      final expectedFilter = stream_chat_flutter.Filter.in_(
        'members',
        const [userId],
      );
      expect(channelsListView.filter, equals(expectedFilter));
    });

    testWidgets('invokes ChannelBuilder when channel tapped', (tester) async {
      const userId = 'test-user-id';
      var channelBuilderCallCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: stream_chat_flutter.StreamChat(
            client: client,
            child: Material(
              child: ChannelListView(
                userId: userId,
                channelBuilder: (context, channel) {
                  channelBuilderCallCount++;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      final channelListViewFinder =
          find.byType(stream_chat_flutter.ChannelListView);
      final channelListView = tester
          .widget<stream_chat_flutter.ChannelListView>(channelListViewFinder);

      channelListView.onChannelTap?.call(MockChannel(), null);

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(channelBuilderCallCount, equals(1));
    });
  });
}
