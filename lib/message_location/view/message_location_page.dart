import 'package:chat_location/message_location/message_location.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageLocationPage extends StatelessWidget {
  const MessageLocationPage({
    Key? key,
    required this.channel,
    required this.message,
  }) : super(key: key);

  final Channel channel;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessageLocationCubit(channel: channel, message: message),
      child: const MessageLocationView(),
    );
  }
}

class MessageLocationView extends StatefulWidget {
  const MessageLocationView({Key? key}) : super(key: key);

  @override
  _MessageLocationViewState createState() => _MessageLocationViewState();
}

class _MessageLocationViewState extends State<MessageLocationView> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessageLocationCubit, MessageLocationState>(
      listener: (context, state) async {
        await mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(state.latitude, state.longitude),
          ),
        );
      },
      builder: (context, state) {
        final position = LatLng(state.latitude, state.longitude);
        final message = state.message;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              message.user!.name,
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
                  zoom: 18,
                ),
                onMapCreated: (controller) => setState(
                  () => mapController = controller,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('user-location-marker-id'),
                    position: position,
                  )
                },
              ),
            ),
            secondChild: Center(
              child: Icon(
                Icons.location_history,
                color: Colors.red.withOpacity(0.76),
              ),
            ),
          ),
        );
      },
    );
  }
}
