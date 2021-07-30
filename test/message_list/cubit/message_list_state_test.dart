import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeChannel extends Fake implements Channel {}

void main() {
  group('MessageListState', () {
    final channel = FakeChannel();
    test('supports value based equality comparisons', () {
      final stateA = MessageListState(channel: channel);
      final stateB = MessageListState(channel: channel);
      expect(stateA, equals(stateB));
    });

    test('copyWith creates a new instance with modified channel', () {
      final otherChannel = FakeChannel();
      final stateA = MessageListState(channel: channel);
      final stateB = stateA.copyWith(channel: otherChannel);
      expect(
        stateB,
        equals(MessageListState(channel: otherChannel)),
      );
    });

    test('copyWith creates a new instance with modified location', () {
      final stateA = MessageListState(channel: channel);
      final stateB = stateA.copyWith(
        location: stateA.location.copyWith(latitude: 42, longtitude: 42),
      );
      expect(
        stateB,
        equals(
          MessageListState(
            channel: channel,
            location: const CurrentLocation(latitude: 42, longtitude: 42),
          ),
        ),
      );
    });
  });
}
