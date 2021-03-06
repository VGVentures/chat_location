part of 'message_list_cubit.dart';

enum CurrentLocationStatus { unavailable, available, pending }

class CurrentLocation extends Equatable {
  const CurrentLocation({
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.status = CurrentLocationStatus.pending,
  });

  final double latitude;
  final double longitude;
  final CurrentLocationStatus status;

  @override
  List<Object> get props => [latitude, longitude, status];

  CurrentLocation copyWith({
    double? latitude,
    double? longitude,
    CurrentLocationStatus? status,
  }) {
    return CurrentLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
    );
  }
}

class MessageListState extends Equatable {
  const MessageListState({
    required this.channel,
    this.location = const CurrentLocation(),
  });

  final Channel channel;
  final CurrentLocation location;

  @override
  List<Object> get props => [channel, location];

  MessageListState copyWith({Channel? channel, CurrentLocation? location}) {
    return MessageListState(
      channel: channel ?? this.channel,
      location: location ?? this.location,
    );
  }
}
