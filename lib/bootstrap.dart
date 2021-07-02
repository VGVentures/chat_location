import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_location/app/app_bloc_observer.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/widgets.dart';

typedef AppBuilder = FutureOr<Widget> Function({
  required ChatRepository chatRepository,
});

Future<void> bootstrap({required AppBuilder builder}) async {
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  const chatApiKey = String.fromEnvironment('CHAT_API_KEY');
  if (chatApiKey.isEmpty) {
    throw StateError('missing environment variable <CHAT_API_KEY>');
  }

  final chatClient = StreamChatClient(chatApiKey, logLevel: Level.OFF);
  final chatRepository = ChatRepository(chatClient: chatClient);

  await runZonedGuarded(
    () async => runApp(await builder(chatRepository: chatRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
