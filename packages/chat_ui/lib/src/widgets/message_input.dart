import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as stream_chat_flutter;

/// {@template message_input}
/// Render a message input which can be used to send new messages.
/// {@endtemplate}
class MessageInput extends StatelessWidget {
  /// {@macro message_input}
  const MessageInput({
    Key? key,
    required stream_chat_flutter.Channel channel,
  })  : _channel = channel,
        super(key: key);

  final stream_chat_flutter.Channel _channel;

  @override
  Widget build(BuildContext context) {
    final channel = context
        .findAncestorStateOfType<stream_chat_flutter.StreamChannelState>();

    if (channel != null) {
      return const stream_chat_flutter.MessageInput();
    }

    return stream_chat_flutter.StreamChannel(
      channel: _channel,
      child: const stream_chat_flutter.MessageInput(),
    );
  }
}
