import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as stream_chat_flutter;

/// {@template message_list_view}
/// Render a list of the current messages based on the provided channel.
/// {@endtemplate}
class MessageListView extends StatelessWidget {
  /// {@macro message_list_view}
  const MessageListView({
    Key? key,
    required stream_chat_flutter.Channel channel,
  })  : _channel = channel,
        super(key: key);

  final stream_chat_flutter.Channel _channel;

  @override
  Widget build(BuildContext context) {
    return stream_chat_flutter.StreamChannel(
      channel: _channel,
      child: const stream_chat_flutter.MessageListView(),
    );
  }
}
