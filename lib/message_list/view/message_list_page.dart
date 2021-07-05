import 'package:chat_repository/chat_repository.dart';
import 'package:chat_ui/chat_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageListPage extends StatelessWidget {
  const MessageListPage({Key? key, required Channel channel})
      : _channel = channel,
        super(key: key);

  final Channel _channel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_channel.team ?? 'Channel'),
      ),
      body: const MessageListView(),
    );
  }
}
