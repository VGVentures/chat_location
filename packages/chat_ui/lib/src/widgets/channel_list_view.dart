import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as stream_chat_flutter;

/// {@template channel_list_view}
/// Render a list of the current channels based on the provided user id.
/// {@endtemplate}
class ChannelListView extends StatelessWidget {
  /// {@macro channel_list_view}
  const ChannelListView({
    Key? key,
    required this.userId,
    required this.channelBuilder,
  }) : super(key: key);

  /// The current user id for which to show messages.
  final String userId;

  /// A [WidgetBuilder] responsible for building the UI for a single channel.
  final Widget Function(
    BuildContext context,
    stream_chat_flutter.Channel channel,
  ) channelBuilder;

  @override
  Widget build(BuildContext context) {
    return stream_chat_flutter.ChannelsBloc(
      child: stream_chat_flutter.ChannelListView(
        filter: stream_chat_flutter.Filter.in_('members', [userId]),
        onChannelTap: (channel, child) {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => channelBuilder(context, channel),
            ),
          );
        },
      ),
    );
  }
}
