// ignore_for_file: prefer_const_constructors
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Location;
import 'package:test/test.dart';
import 'package:chat_repository/chat_repository.dart' hide Location;

class MockLocation extends Mock implements Location {}

class MockStreamChatClient extends Mock implements StreamChatClient {}

class MockClientState extends Mock implements ClientState {}

class MockOwnUser extends Mock implements OwnUser {}

class FakeChannelState extends Fake implements ChannelState {}

class FakeEvent extends Fake implements Event {}

class FakeUser extends Fake implements User {}

class FakeOwnUser extends Fake implements OwnUser {}

void main() {
  group('ChatRepository', () {
    late StreamChatClient chatClient;
    late ChatRepository chatRepository;
    late Location location;

    setUpAll(() {
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      chatClient = MockStreamChatClient();
      location = MockLocation();
      chatRepository = ChatRepository(
        chatClient: chatClient,
        location: location,
      );
    });

    test('can be instantiated without any arguments', () {
      expect(ChatRepository(), isNotNull);
    });

    group('connect', () {
      const userId = 'test-user-id';
      const token = 'test-token';
      final avatarUri = Uri.https('test.com', 'profile/pic.png');

      test('connects with the provided userId, token, and avatarUri', () {
        when(
          () => chatClient.connectUser(any(), any()),
        ).thenAnswer((_) async => FakeOwnUser());

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
        when(() => state.currentUser).thenReturn(null);

        expect(
          () => chatRepository.getUserId(),
          throwsStateError,
        );
      });

      test('returns correct user id when user has connected', () {
        final state = MockClientState();
        final user = MockOwnUser();

        when(() => chatClient.state).thenReturn(state);
        when(() => state.currentUser).thenReturn(user);
        when(() => user.id).thenReturn(userId);

        expect(
          chatRepository.getUserId(),
          equals(userId),
        );

        verify(() => chatClient.state).called(1);
        verify(() => state.currentUser).called(1);
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

    group('getCurrentLocation', () {
      test('throws CurrentLocationFailure when service is not enabled', () {
        when(() => location.serviceEnabled()).thenAnswer((_) async => false);
        when(() => location.requestService()).thenAnswer((_) async => false);

        expect(
          () => chatRepository.getCurrentLocation(),
          throwsA(isA<CurrentLocationFailure>()),
        );
      });

      test('throws CurrentLocationFailure when permission is not granted', () {
        when(() => location.serviceEnabled()).thenAnswer((_) async => true);
        when(() => location.hasPermission()).thenAnswer(
          (_) async => PermissionStatus.denied,
        );
        when(() => location.requestPermission()).thenAnswer(
          (_) async => PermissionStatus.denied,
        );

        expect(
          () => chatRepository.getCurrentLocation(),
          throwsA(isA<CurrentLocationFailure>()),
        );
      });

      test('throws CurrentLocationFailure when location is unavailable', () {
        when(() => location.serviceEnabled()).thenAnswer((_) async => true);
        when(() => location.hasPermission()).thenAnswer(
          (_) async => PermissionStatus.granted,
        );
        when(() => location.getLocation()).thenThrow(Exception());

        expect(
          () => chatRepository.getCurrentLocation(),
          throwsA(isA<CurrentLocationFailure>()),
        );
      });

      test('throws CurrentLocationFailure when location is null', () {
        when(() => location.serviceEnabled()).thenAnswer((_) async => true);
        when(() => location.hasPermission()).thenAnswer(
          (_) async => PermissionStatus.granted,
        );
        when(() => location.getLocation()).thenAnswer(
          (_) async => LocationData.fromMap({}),
        );

        expect(
          () => chatRepository.getCurrentLocation(),
          throwsA(isA<CurrentLocationFailure>()),
        );
      });

      test('returns CoordinatePair when location is available', () async {
        const latitude = 42.0;
        const longitude = 13.37;
        when(() => location.serviceEnabled()).thenAnswer((_) async => true);
        when(() => location.hasPermission()).thenAnswer(
          (_) async => PermissionStatus.granted,
        );
        when(() => location.getLocation()).thenAnswer(
          (_) async => LocationData.fromMap({
            'latitude': latitude,
            'longitude': longitude,
          }),
        );

        expect(
          await chatRepository.getCurrentLocation(),
          isA<CoordinatePair>()
              .having((c) => c.latitude, 'latitude', latitude)
              .having((c) => c.longitude, 'longitude', longitude),
        );
      });
    });
  });
}
