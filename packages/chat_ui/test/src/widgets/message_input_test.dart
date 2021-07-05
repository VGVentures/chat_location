import 'package:chat_ui/chat_ui.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('MessageInput', () {
    late stream_chat_flutter.StreamChatClient client;
    late stream_chat_flutter.Channel channel;

    setUp(() {
      client = MockStreamChatClient();
      when(() => client.on(any(), any(), any(), any()))
          .thenAnswer((_) => const Stream.empty());
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

    testWidgets('renders message input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: stream_chat_flutter.StreamChat(
            client: client,
            child: MessageInput(channel: channel),
          ),
        ),
      );
      await tester.pumpAndSettle();
      tester.takeException();
      expect(find.byType(stream_chat_flutter.MessageInput), findsOneWidget);
    });
  });
}
