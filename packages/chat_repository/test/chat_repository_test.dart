// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';
import 'package:chat_repository/chat_repository.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

class FakeChannelState extends Fake implements ChannelState {}

void main() {
  group('ChatRepository', () {
    late StreamChatClient chatClient;
    late ChatRepository chatRepository;

    setUp(() {
      chatClient = MockStreamChatClient();
      chatRepository = ChatRepository(chatClient: chatClient);
    });

    group('joinMessagingChannel', () {
      const channelId = 'test-channel-id';

      test('joins correct messaging channel based on the provided id', () {
        when(
          () => chatClient.watchChannel(
            any(),
            channelId: any(named: 'channelId'),
          ),
        ).thenAnswer((_) async => FakeChannelState());
        chatRepository.joinMessagingChannel(id: channelId);
        verify(
          () => chatClient.watchChannel('messaging', channelId: channelId),
        ).called(1);
      });
    });
  });
}
