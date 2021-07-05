// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';
import 'package:chat_repository/chat_repository.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

class MockClientState extends Mock implements ClientState {}

class MockOwnUser extends Mock implements OwnUser {}

class FakeChannelState extends Fake implements ChannelState {}

class FakeEvent extends Fake implements Event {}

class FakeUser extends Fake implements User {}

void main() {
  group('ChatRepository', () {
    late StreamChatClient chatClient;
    late ChatRepository chatRepository;

    setUpAll(() {
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      chatClient = MockStreamChatClient();
      chatRepository = ChatRepository(chatClient: chatClient);
    });

    group('connect', () {
      const userId = 'test-user-id';
      const token = 'test-token';
      final avatarUri = Uri.https('test.com', 'profile/pic.png');

      test('connects with the provided userId, token, and avatarUri', () {
        when(
          () => chatClient.connectUser(any(), any()),
        ).thenAnswer((_) async => FakeEvent());

        expect(
          chatRepository.connect(
            userId: userId,
            token: token,
            avatarUri: avatarUri,
          ),
          completes,
        );

        verify(
          () => chatClient.connectUser(
            User(id: userId, extraData: {'image': '$avatarUri'}),
            token,
          ),
        ).called(1);
      });
    });

    group('getUserId', () {
      const userId = 'test-user-id';

      test('throws StateError when user has not connected', () {
        final state = MockClientState();

        when(() => chatClient.state).thenReturn(state);
        when(() => state.user).thenReturn(null);

        expect(
          () => chatRepository.getUserId(),
          throwsStateError,
        );
      });

      test('returns correct user id when user has connected', () {
        final state = MockClientState();
        final user = MockOwnUser();

        when(() => chatClient.state).thenReturn(state);
        when(() => state.user).thenReturn(user);
        when(() => user.id).thenReturn(userId);

        expect(
          chatRepository.getUserId(),
          equals(userId),
        );

        verify(() => chatClient.state).called(1);
        verify(() => state.user).called(1);
        verify(() => user.id).called(1);
      });
    });

    group('joinMessagingChannel', () {
      const channelId = 'test-channel-id';

      test('joins messaging channel with the provided id', () {
        when(
          () => chatClient.watchChannel(
            any(),
            channelId: any(named: 'channelId'),
          ),
        ).thenAnswer((_) async => FakeChannelState());

        expect(chatRepository.joinMessagingChannel(id: channelId), completes);

        verify(
          () => chatClient.watchChannel('messaging', channelId: channelId),
        ).called(1);
      });
    });
  });
}
