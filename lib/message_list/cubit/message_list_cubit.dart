import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:equatable/equatable.dart';

part 'message_list_state.dart';

class MessageListCubit extends Cubit<MessageListState> {
  MessageListCubit({
    required Channel channel,
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(MessageListState(channel: channel));

  final ChatRepository _chatRepository;

  Future<void> locationRequested() async {
    emit(
      state.copyWith(
        location: state.location.copyWith(
          status: CurrentLocationStatus.pending,
        ),
      ),
    );

    try {
      final location = await _chatRepository.getCurrentLocation();
      emit(
        state.copyWith(
          location: state.location.copyWith(
            status: CurrentLocationStatus.available,
            latitude: location.latitude,
            longtitude: location.longitude,
          ),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          location: state.location.copyWith(
            status: CurrentLocationStatus.unavailable,
          ),
        ),
      );
    }
  }
}
