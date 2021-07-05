part of 'message_list_cubit.dart';

class MessageListState extends Equatable {
  const MessageListState({required this.channel});

  final Channel channel;

  @override
  List<Object> get props => [channel];
}
