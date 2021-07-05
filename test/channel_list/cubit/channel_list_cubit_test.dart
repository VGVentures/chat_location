import 'package:chat_location/channel_list/channel_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  group('ChannelListCubit', () {
    late ChatRepository chatRepository;

    setUp(() {
      chatRepository = MockChatRepository();
    });

    group('initial state', () {
      test('contains correct userId', () {
        const userId = 'test-user-id';
        when(() => chatRepository.getUserId()).thenReturn(userId);

        final channelListCubit = ChannelListCubit(
          chatRepository: chatRepository,
        );

        expect(
          channelListCubit.state,
          equals(const ChannelListState(userId: userId)),
        );
      });
    });
  });
}
