import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as stream_chat_flutter;

/// {@template channel_app_bar}
/// Render an app bar based on the provided channel.
/// {@endtemplate}
class ChannelAppBar extends StatelessWidget with PreferredSizeWidget {
  /// {@macro channel_app_bar}
  const ChannelAppBar({
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
      return const stream_chat_flutter.ChannelHeader();
    }

    return stream_chat_flutter.StreamChannel(
      channel: _channel,
      child: const stream_chat_flutter.ChannelHeader(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
