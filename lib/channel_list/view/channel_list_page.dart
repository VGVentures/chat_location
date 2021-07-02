import 'package:flutter/material.dart';
import 'package:chat_location/l10n/l10n.dart';

class ChannelListPage extends StatelessWidget {
  const ChannelListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.channelListAppBarTitle)),
    );
  }
}
