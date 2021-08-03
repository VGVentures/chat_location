import 'package:bloc_test/bloc_test.dart';
import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChannel extends Mock implements Channel {}

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  group('MessageListCubit', () {
    late Channel channel;
    late ChatRepository chatRepository;

    setUp(() {
      channel = MockChannel();
      chatRepository = MockChatRepository();
    });

    group('initial state', () {
      test('contains correct userId', () {
        final cubit = MessageListCubit(
          channel: channel,
          chatRepository: chatRepository,
        );

        expect(
          cubit.state,
          equals(MessageListState(channel: channel)),
        );
      });
    });

    group('locationRequested', () {
      const latitude = 42.0;
      const longitude = 13.37;
      const coordinatePair = CoordinatePair(
        latitude: latitude,
        longitude: longitude,
      );
      blocTest<MessageListCubit, MessageListState>(
        'emits [pending, unavailable] when location is unavailable',
        build: () {
          when(
            () => chatRepository.getCurrentLocation(),
          ).thenThrow(Exception());
          return MessageListCubit(
            channel: channel,
            chatRepository: chatRepository,
          );
        },
        act: (cubit) => cubit.locationRequested(),
        expect: () => [
          MessageListState(
            channel: channel,
            location: const CurrentLocation(
              status: CurrentLocationStatus.pending,
            ),
          ),
          MessageListState(
            channel: channel,
            location: const CurrentLocation(
              status: CurrentLocationStatus.unavailable,
            ),
          )
        ],
      );

      blocTest<MessageListCubit, MessageListState>(
        'emits [pending, available] when location is available',
        build: () {
          when(
            () => chatRepository.getCurrentLocation(),
          ).thenAnswer((_) async => coordinatePair);
          return MessageListCubit(
            channel: channel,
            chatRepository: chatRepository,
          );
        },
        act: (cubit) => cubit.locationRequested(),
        expect: () => [
          MessageListState(
            channel: channel,
            location: const CurrentLocation(
              status: CurrentLocationStatus.pending,
            ),
          ),
          MessageListState(
            channel: channel,
            location: const CurrentLocation(
              latitude: latitude,
              longitude: longitude,
              status: CurrentLocationStatus.available,
            ),
          )
        ],
      );
    });
  });
}
