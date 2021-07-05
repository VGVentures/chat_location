import 'package:chat_location/channel_list/channel_list.dart';
import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:chat_ui/chat_ui.dart' as chat_ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class FakeBuildContext extends Fake implements BuildContext {}

class FakeChannel extends Fake implements Channel {}

void main() {
  group('ChannelListPage', () {
    const userId = 'test-user-id';

    late ChatRepository chatRepository;

    setUp(() {
      chatRepository = MockChatRepository();
    });

    testWidgets('renders ChannelListView', (tester) async {
      when(() => chatRepository.getUserId()).thenReturn(userId);

      await tester.pumpApp(
        const ChannelListPage(),
        chatRepository: chatRepository,
      );

      expect(find.byType(ChannelListView), findsOneWidget);
    });

    testWidgets('renders chat_ui.ChannelListView', (tester) async {
      when(() => chatRepository.getUserId()).thenReturn(userId);

      await tester.pumpApp(
        const ChannelListPage(),
        chatRepository: chatRepository,
      );

      final channelListViewFinder = find.byType(chat_ui.ChannelListView);
      final channelListView = tester.widget<chat_ui.ChannelListView>(
        channelListViewFinder,
      );
      expect(channelListView.userId, equals(userId));
    });

    testWidgets('renders MessageListPage when channel is tapped',
        (tester) async {
      when(() => chatRepository.getUserId()).thenReturn(userId);

      await tester.pumpApp(
        const ChannelListPage(),
        chatRepository: chatRepository,
      );

      final channelListViewFinder = find.byType(chat_ui.ChannelListView);
      final channelListView = tester.widget<chat_ui.ChannelListView>(
        channelListViewFinder,
      );
      expect(
        channelListView.channelBuilder(FakeBuildContext(), FakeChannel()),
        isA<MessageListPage>(),
      );
    });
  });
}
