import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chat_ui/chat_ui.dart' as chat_ui;

import '../../helpers/helpers.dart';

class MockChannel extends Mock implements Channel {}

class MockChannelClientState extends Mock implements ChannelClientState {}

void main() {
  group('MessageListPage', () {
    late Channel channel;

    setUp(() {
      channel = MockChannel();

      final channelClientState = MockChannelClientState();
      when(() => channel.initialized).thenAnswer((_) async => true);
      when(() => channel.on(any(), any(), any(), any())).thenAnswer(
        (_) => const Stream.empty(),
      );
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

    testWidgets('renders a MessageListView', (tester) async {
      await tester.pumpApp(
        MessageListPage(channel: channel),
      );
      await tester.pumpAndSettle();
      await tester.takeException();
      expect(find.byType(MessageListView), findsOneWidget);
    });

    testWidgets('renders chat_ui.MessageListView', (tester) async {
      await tester.pumpApp(
        MessageListPage(channel: channel),
      );
      await tester.pumpAndSettle();
      await tester.takeException();
      expect(find.byType(chat_ui.MessageListView), findsOneWidget);
    });

    testWidgets('renders chat_ui.MessageInput', (tester) async {
      await tester.pumpApp(
        MessageListPage(channel: channel),
      );
      await tester.pumpAndSettle();
      await tester.takeException();
      expect(find.byType(chat_ui.MessageInput), findsOneWidget);
    });
  });
}
