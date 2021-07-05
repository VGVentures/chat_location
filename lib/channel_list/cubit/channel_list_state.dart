part of 'channel_list_cubit.dart';

class ChannelListState extends Equatable {
  const ChannelListState({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}
