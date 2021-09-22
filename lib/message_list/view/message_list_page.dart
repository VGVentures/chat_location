import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_location/message_location/message_location.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:chat_ui/chat_ui.dart' as chat_ui;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageListPage extends StatelessWidget {
  const MessageListPage({Key? key, required Channel channel})
      : _channel = channel,
        super(key: key);

  final Channel _channel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chat_ui.ChannelAppBar(channel: _channel),
      body: BlocProvider(
        create: (context) => MessageListCubit(
          channel: _channel,
          chatRepository: context.read<ChatRepository>(),
        ),
        child: const MessageListView(),
      ),
    );
  }
}

class MessageListView extends StatefulWidget {
  const MessageListView({Key? key}) : super(key: key);

  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  late final chat_ui.MessageInputController _controller;

  @override
  void initState() {
    super.initState();
    _controller = chat_ui.MessageInputController();
  }

  @override
  Widget build(BuildContext context) {
    final channel = context.select(
      (MessageListCubit cubit) => cubit.state.channel,
    );
    return BlocListener<MessageListCubit, MessageListState>(
      listenWhen: (prev, curr) => prev.location.status != curr.location.status,
      listener: (context, state) {
        if (state.location.status == CurrentLocationStatus.unavailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '''We can't access your location at this time. Did you allow location access?''',
              ),
            ),
          );
        }

        if (state.location.status == CurrentLocationStatus.available) {
          _controller.addAttachment(
            Attachment(
              type: 'location',
              uploadState: const UploadState.success(),
              extraData: {
                'latitude': state.location.latitude,
                'longitude': state.location.longitude,
              },
            ),
          );
        }
      },
      child: Column(
        children: [
          Expanded(
            child: chat_ui.MessageListView(
              channel: channel,
              onGenerateAttachments: {
                'location': (_, message) => AttachmentView(message: message)
              },
            ),
          ),
          chat_ui.MessageInput(
            controller: _controller,
            channel: channel,
            onGenerateAttachementThumbnails: {
              'location': (context, attachment) {
                return MapThumbnailImage(
                  latitude: attachment.extraData['latitude'] as double?,
                  longitude: attachment.extraData['longitude'] as double?,
                );
              },
            },
            actions: [
              IconButton(
                icon: const Icon(Icons.location_history),
                onPressed: () async {
                  await context.read<MessageListCubit>().locationRequested();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AttachmentView extends StatelessWidget {
  const AttachmentView({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final latitude = message.attachments.first.extraData['latitude'] ?? 0.0;
    final longitude = message.attachments.first.extraData['longitude'] ?? 0.0;
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute<MessageLocationPage>(
            builder: (_) => MessageLocationPage(message: message),
          ),
        );
      },
      child: chat_ui.Attachment(
        child: MapThumbnailImage(
          latitude: latitude as double,
          longitude: longitude as double,
        ),
      ),
    );
  }
}

class MapThumbnailImage extends StatelessWidget {
  const MapThumbnailImage({
    Key? key,
    this.latitude = 0,
    this.longitude = 0,
  }) : super(key: key);

  final double? latitude;
  final double? longitude;

  Uri get _thumbnailUri {
    return Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      port: 443,
      path: '/maps/api/staticmap',
      queryParameters: <String, String>{
        'center': '$latitude,$longitude',
        'zoom': '18',
        'size': '700x500',
        'maptype': 'roadmap',
        'key': 'AIzaSyAs6Lu9NlFJHyEYGcepupdrk20iDjg-Uys',
        'markers': 'color:red|$latitude,$longitude'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '$_thumbnailUri',
      height: 300,
      width: 600,
      fit: BoxFit.fill,
    );
  }
}
