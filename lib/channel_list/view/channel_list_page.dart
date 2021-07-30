import 'package:chat_location/channel_list/channel_list.dart';
import 'package:chat_location/l10n/l10n.dart';
import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:chat_ui/chat_ui.dart' as chat_ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelListPage extends StatelessWidget {
  const ChannelListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.channelListAppBarTitle)),
      body: BlocProvider(
        create: (context) => ChannelListCubit(
          chatRepository: context.read<ChatRepository>(),
        ),
        child: const ChannelListView(),
      ),
    );
  }
}

class ChannelListView extends StatelessWidget {
  const ChannelListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = context.select(
      (ChannelListCubit cubit) => cubit.state.userId,
    );
    return chat_ui.ChannelListView(
      userId: userId,
      channelBuilder: (_, channel) => MessageListPage(channel: channel),
    );
  }
}
