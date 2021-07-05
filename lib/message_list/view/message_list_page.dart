import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:chat_ui/chat_ui.dart' as chat_ui;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_location/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageListPage extends StatelessWidget {
  const MessageListPage({Key? key, required Channel channel})
      : _channel = channel,
        super(key: key);

  final Channel _channel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.messageListAppBarTitle)),
      body: BlocProvider(
        create: (context) => MessageListCubit(channel: _channel),
        child: const MessageListView(),
      ),
    );
  }
}

class MessageListView extends StatelessWidget {
  const MessageListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channel = context.select(
      (MessageListCubit cubit) => cubit.state.channel,
    );
    return Column(
      children: [
        Expanded(child: chat_ui.MessageListView(channel: channel)),
        chat_ui.MessageInput(channel: channel),
      ],
    );
  }
}
