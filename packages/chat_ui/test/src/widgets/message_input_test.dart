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

    testWidgets('supports adding attachments', (tester) async {
      final controller = MessageInputController();
      await tester.pumpWidget(
        MaterialApp(
          home: stream_chat_flutter.StreamChat(
            client: client,
            child: MessageInput(
              channel: channel,
              controller: controller,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      tester.takeException();
      controller.addAttachment(stream_chat_flutter.Attachment());
      expect(tester.takeException(), isNull);
    });

    testWidgets('invokes onGenerateAttachements', (tester) async {
      final controller = MessageInputController();
      var onGenerateAttachementThumbnailsCallCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: stream_chat_flutter.StreamChat(
            client: client,
            child: MessageInput(
              controller: controller,
              channel: channel,
              onGenerateAttachementThumbnails: {
                'custom': (context, details) {
                  onGenerateAttachementThumbnailsCallCount++;
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      tester.takeException();
      controller.addAttachment(stream_chat_flutter.Attachment(
        type: 'custom',
        uploadState: const stream_chat_flutter.UploadState.success(),
        extraData: const {},
      ));
      await tester.pumpAndSettle();
      tester.takeException();
      expect(onGenerateAttachementThumbnailsCallCount, equals(1));
    });
  });
}
