import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChannelPage extends StatelessWidget {
  const ChannelPage({Key? key, required Channel channel})
      : _channel = channel,
        super(key: key);

  final Channel _channel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_channel.team ?? 'Channel'),
      ),
    );
  }
}
