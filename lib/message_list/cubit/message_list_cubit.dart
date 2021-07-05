import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'message_list_state.dart';

class MessageListCubit extends Cubit<MessageListState> {
  MessageListCubit({required Channel channel})
      : super(MessageListState(channel: channel));
}
