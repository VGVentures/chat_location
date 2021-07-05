import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as stream_chat_flutter;

/// {@template message_list_view}
/// Render a list of the current messages based on the provided user id.
/// {@endtemplate}
class MessageListView extends StatelessWidget {
  /// {@macro message_list_view}
  const MessageListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const stream_chat_flutter.MessageListView();
  }
}
