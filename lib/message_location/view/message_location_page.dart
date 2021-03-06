import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageLocationPage extends StatelessWidget {
  const MessageLocationPage({
    Key? key,
    required this.message,
  }) : super(key: key);

  static Route route(Message message) {
    return MaterialPageRoute<void>(
      builder: (_) => MessageLocationPage(message: message),
    );
  }

  final Message message;

  @override
  Widget build(BuildContext context) {
    final latitude = message.attachments.first.extraData['latitude'] ?? 0.0;
    final longitude = message.attachments.first.extraData['longitude'] ?? 0.0;
    final position = LatLng(latitude as double, longitude as double);
    return Scaffold(
      appBar: AppBar(
        title: Text(message.user?.name ?? '...'),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.loose(MediaQuery.of(context).size),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: position, zoom: 15),
          markers: {
            Marker(
              markerId: const MarkerId('user-location-marker-id'),
              position: position,
            ),
          },
        ),
      ),
    );
  }
}
