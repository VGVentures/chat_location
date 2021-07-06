import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as stream_chat_flutter;

/// Type definition for `onGenerateAttachementThumbnails`.
typedef OnGenerateAttachementThumbnails = Map<String,
    Widget Function(BuildContext, stream_chat_flutter.Attachment)>;

/// A controller for the [MessageInput] widget.
class MessageInputController {
  GlobalKey<stream_chat_flutter.MessageInputState>? _key;

  /// Adds a custom attachment to the message.
  void addAttachment(stream_chat_flutter.Attachment attachment) {
    _key?.currentState?.addAttachment(attachment);
  }
}

/// {@template message_input}
/// Render a message input which can be used to send new messages.
/// {@endtemplate}
class MessageInput extends StatefulWidget {
  /// {@macro message_input}
  const MessageInput({
    Key? key,
    required stream_chat_flutter.Channel channel,
    OnGenerateAttachementThumbnails? onGenerateAttachementThumbnails,
    List<Widget>? actions,
    MessageInputController? controller,
  })  : _channel = channel,
        _onGenerateAttachementThumbnails =
            onGenerateAttachementThumbnails ?? const {},
        _actions = actions ?? const [],
        _controller = controller,
        super(key: key);

  final stream_chat_flutter.Channel _channel;
  final OnGenerateAttachementThumbnails _onGenerateAttachementThumbnails;
  final List<Widget> _actions;
  final MessageInputController? _controller;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _messageInputKey = GlobalKey<stream_chat_flutter.MessageInputState>();

  @override
  void initState() {
    super.initState();
    widget._controller?._key = _messageInputKey;
  }

  @override
  Widget build(BuildContext context) {
    final channel = context
        .findAncestorStateOfType<stream_chat_flutter.StreamChannelState>();
    final messageInput = stream_chat_flutter.MessageInput(
      key: _messageInputKey,
      actions: widget._actions,
      attachmentThumbnailBuilders: widget._onGenerateAttachementThumbnails,
    );

    if (channel != null) return messageInput;

    return stream_chat_flutter.StreamChannel(
      channel: widget._channel,
      child: messageInput,
    );
  }
}
