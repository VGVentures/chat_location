part of 'message_location_cubit.dart';

class MessageLocationState extends Equatable {
  const MessageLocationState({
    required this.latitude,
    required this.longitude,
    required this.message,
  });

  final double latitude;
  final double longitude;
  final Message message;

  @override
  List<Object> get props => [latitude, longitude];
}
