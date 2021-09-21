import 'package:chat_ui/chat_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as stream_chat_flutter;

class MockStreamChatClient extends Mock
    implements stream_chat_flutter.StreamChatClient {}

class MockChannel extends Mock implements stream_chat_flutter.Channel {}

class MockChannelClientState extends Mock
    implements stream_chat_flutter.ChannelClientState {}

class FakeBuildContext extends Fake implements BuildContext {}

class FakeMessage extends Fake implements stream_chat_flutter.Message {}

class FakeMessageDetails extends Fake
    implements stream_chat_flutter.MessageDetails {}

class FakeMessageTheme extends Fake
    implements stream_chat_flutter.MessageThemeData {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

void main() {
  group('MessageListView', () {
    late stream_chat_flutter.StreamChatClient client;
    late stream_chat_flutter.Channel channel;

    setUp(() {
      client = MockStreamChatClient();
      when(() => client.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());
      when(() => client.wsConnectionStatus)
          .thenReturn(stream_chat_flutter.ConnectionStatus.connected);
      channel = MockChannel();
      when(() => channel.initialized).thenAnswer((_) async => true);
      when(() => channel.on(any(), any(), any(), any())).thenAnswer(
        (_) => const Stream.empty(),
      );
      final channelClientState = MockChannelClientState();
      when(() => channel.state).thenReturn(channelClientState);
      when(() => channelClientState.threadsStream).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => channelClientState.messagesStream).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => channelClientState.messages).thenReturn([]);
      when(() => channelClientState.isUpToDate).thenReturn(true);
    });

    testWidgets('renders message list view', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: stream_chat_flutter.StreamChat(
            client: client,
            child: MessageListView(channel: channel),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(stream_chat_flutter.MessageListView), findsOneWidget);
    });

    testWidgets('supports custom attachment builders', (tester) async {
      var onGenerateAttachementsCallCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: stream_chat_flutter.StreamChat(
            client: client,
            child: MessageListView(
              channel: channel,
              onGenerateAttachements: {
                'custom': (context, attachment) {
                  onGenerateAttachementsCallCount++;
                  return const SizedBox();
                },
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final messageListViewFinder =
          find.byType(stream_chat_flutter.MessageListView);
      (tester
              .widget<stream_chat_flutter.MessageListView>(
                  messageListViewFinder)
              .messageBuilder
              ?.call(
                FakeBuildContext(),
                FakeMessageDetails(),
                [],
                stream_chat_flutter.MessageWidget(
                  message: FakeMessage(),
                  messageTheme: FakeMessageTheme(),
                ),
              ) as stream_chat_flutter.MessageWidget?)
          ?.attachmentBuilders['custom']
          ?.call(FakeBuildContext(), FakeMessage(), []);
      expect(onGenerateAttachementsCallCount, equals(1));
    });
  });
}
