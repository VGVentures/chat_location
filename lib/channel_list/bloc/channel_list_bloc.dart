import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'channel_list_event.dart';
part 'channel_list_state.dart';

class ChannelListBloc extends Bloc<ChannelListEvent, ChannelListState> {
  ChannelListBloc({required ChatRepository chatRepository})
      : super(ChannelListState(userId: chatRepository.getUserId()));

  @override
  Stream<ChannelListState> mapEventToState(ChannelListEvent event) async* {}
}
