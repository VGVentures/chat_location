import 'package:stream_chat/stream_chat.dart';

/// {@template chat_repository}
/// Repository which manages the chat domain.
/// {@endtemplate}
class ChatRepository {
  /// {@macro chat_repository}
  const ChatRepository({required StreamChatClient chatClient})
      : _chatClient = chatClient;

  final StreamChatClient _chatClient;

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
}
