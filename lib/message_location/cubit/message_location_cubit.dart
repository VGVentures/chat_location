import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'message_location_state.dart';

class MessageLocationCubit extends Cubit<MessageLocationState> {
  MessageLocationCubit({
    required Channel channel,
    required Message message,
  })  : _message = message,
        super(
          MessageLocationState(latitude: 0, longitude: 0, message: message),
        ) {
    _messageSubscription =
        channel.on('location_update').listen(_locationChanged);
  }

  final Message _message;
  late StreamSubscription _messageSubscription;

  void _locationChanged(Event event) {
    var newLatitude = event.extraData['lat'] as double;
    var newLongitude = event.extraData['long'] as double;

    emit(
      MessageLocationState(
        latitude: newLatitude,
        longitude: newLongitude,
        message: _message,
      ),
    );
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    return super.close();
  }
}
