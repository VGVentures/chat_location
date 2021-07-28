import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as stream_chat_flutter;

/// Type definition for `onGenerateAttachements`.
typedef OnGenerateAttachements
    = Map<String, Widget Function(BuildContext, stream_chat_flutter.Message)>;

typedef _CustomAttachementBuilder = Widget Function(
  BuildContext,
  stream_chat_flutter.Message,
  List<stream_chat_flutter.Attachment>,
);

/// {@template message_list_view}
/// Render a list of the current messages based on the provided channel.
/// {@endtemplate}
class MessageListView extends StatelessWidget {
  /// {@macro message_list_view}
  const MessageListView({
    Key? key,
    required stream_chat_flutter.Channel channel,
    OnGenerateAttachements? onGenerateAttachements,
  })  : _channel = channel,
        _onGenerateAttachements = onGenerateAttachements ?? const {},
        super(key: key);

  final stream_chat_flutter.Channel _channel;
  final OnGenerateAttachements _onGenerateAttachements;

  @override
  Widget build(BuildContext context) {
    final channel = context
        .findAncestorStateOfType<stream_chat_flutter.StreamChannelState>();

    final customAttachmentBuilder = <String, _CustomAttachementBuilder>{};
    for (final entry in _onGenerateAttachements.entries) {
      customAttachmentBuilder[entry.key] = (context, details, attachments) {
        return entry.value(context, details);
      };
    }

    final messageListView = stream_chat_flutter.MessageListView(
      parentMessageBuilder: customAttachmentBuilder,
    );

    if (channel != null) return messageListView;

    return stream_chat_flutter.StreamChannel(
      channel: _channel,
      child: messageListView,
    );
  }
}
