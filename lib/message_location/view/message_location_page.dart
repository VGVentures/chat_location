import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageLocationPage extends StatefulWidget {
  const MessageLocationPage({
    Key? key,
    required this.message,
  }) : super(key: key);

  static Route<void> route({required Message message}) {
    return MaterialPageRoute(
      builder: (_) => MessageLocationPage(message: message),
    );
  }

  final Message message;

  @override
  _MessageLocationPageState createState() => _MessageLocationPageState();
}

class _MessageLocationPageState extends State<MessageLocationPage> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final latitude =
        widget.message.attachments.first.extraData['latitude'] ?? 0.0;
    final longitude =
        widget.message.attachments.first.extraData['longitude'] ?? 0.0;
    final position = LatLng(latitude as double, longitude as double);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.message.user!.name,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: AnimatedCrossFade(
        duration: kThemeAnimationDuration,
        crossFadeState: mapController != null
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: ConstrainedBox(
          constraints: BoxConstraints.loose(MediaQuery.of(context).size),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 15,
            ),
            onMapCreated: (controller) => setState(
              () => mapController = controller,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('user-location-marker-id'),
                position: position,
              ),
            },
          ),
        ),
        secondChild: Center(
          child: Icon(
            Icons.location_history,
            size: 30,
            color: Colors.red.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
