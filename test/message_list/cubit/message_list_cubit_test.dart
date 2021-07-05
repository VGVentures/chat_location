import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChannel extends Mock implements Channel {}

void main() {
  group('MessageListCubit', () {
    late Channel channel;

    setUp(() {
      channel = MockChannel();
    });

    group('initial state', () {
      test('contains correct userId', () {
        final cubit = MessageListCubit(channel: channel);

        expect(
          cubit.state,
          equals(MessageListState(channel: channel)),
        );
      });
    });
  });
}
