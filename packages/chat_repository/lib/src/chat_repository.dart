import 'package:location/location.dart';
import 'package:stream_chat/stream_chat.dart' hide Location;

/// Generic Exception throw during `getCurrentLocationUri`
/// if there is an issue determining the user's location.
class CurrentLocationFailure implements Exception {}

/// {@template coordinate_pair}
/// Models which represents a coordinate pair consisting
/// of latitude and longitude.
class CoordinatePair {
  /// {@macro coordinate_pair}
  const CoordinatePair({
    required this.latitude,
    required this.longitude,
  });

  /// The current latitude.
  final double latitude;

  /// The current longitude.
  final double longitude;
}

/// {@template chat_repository}
/// Repository which manages the chat domain.
/// {@endtemplate}
class ChatRepository {
  /// {@macro chat_repository}
  ChatRepository({
    StreamChatClient? chatClient,
    Location? location,
  })  : _chatClient = chatClient ?? StreamChatClient('<PLACEHOLDER_API_KEY>'),
        _location = location ?? Location();

  final StreamChatClient _chatClient;
  final Location _location;

  /// Return the current user's id.
  /// Throws a [StateError] if called before calling [connect].
  String getUserId() {
    final user = _chatClient.state.currentUser;
    if (user == null) {
      throw StateError(
        'could not retrieve user. did you forget to call connect()?',
      );
    }
    return user.id;
  }

  /// Connect to chat with the provided [userId] and [token].
  /// An optional [avatarUri] can be provided to customize the current avatar.
  Future<void> connect({
    required String userId,
    required String token,
    Uri? avatarUri,
  }) {
    final extraData = <String, String>{};
    if (avatarUri != null) {
      extraData['image'] = '$avatarUri';
    }
    return _chatClient.connectUser(
      User(id: userId, extraData: extraData),
      token,
    );
  }

  /// Join a messaging channel with the provided [id].
  Future<void> joinMessagingChannel({required String id}) {
    return _chatClient.watchChannel('messaging', channelId: id);
  }

  /// Returns a [CoordinatePair] containing the user's current location.
  /// Throws [CurrentLocationFailure] when there is an issue
  /// accessing the user's current location.
  Future<CoordinatePair> getCurrentLocation() async {
    final serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      final isEnabled = await _location.requestService();
      if (!isEnabled) throw CurrentLocationFailure();
    }

    final permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      final status = await _location.requestPermission();
      if (status != PermissionStatus.granted) throw CurrentLocationFailure();
    }

    late final LocationData locationData;
    try {
      locationData = await _location.getLocation();
    } catch (_) {
      throw CurrentLocationFailure();
    }

    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) throw CurrentLocationFailure();

    return CoordinatePair(latitude: latitude, longitude: longitude);
  }
}
