import 'package:stream_chat/stream_chat.dart';

/// {@template chat_repository}
/// Repository which manages the chat domain.
/// {@endtemplate}
class ChatRepository {
  /// {@macro chat_repository}
  const ChatRepository({required StreamChatClient chatClient})
      : _chatClient = chatClient;

  final StreamChatClient _chatClient;

  /// Join a messaging channel with the provided [id].
  Future<void> joinMessagingChannel({required String id}) {
    return _chatClient.watchChannel('messaging', channelId: id);
  }
}
