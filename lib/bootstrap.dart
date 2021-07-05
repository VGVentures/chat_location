// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_location/app/app_bloc_observer.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:chat_ui/chat_ui.dart' as chat_ui;

typedef AppBuilder = FutureOr<Widget> Function(
  Widget Function(Widget) builder,
  ChatRepository chatRepository,
);

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

  const chatToken = String.fromEnvironment('CHAT_TOKEN');
  if (chatToken.isEmpty) {
    throw StateError('missing environment variable <CHAT_TOKEN>');
  }

  const userId = 'neevash';
  final avatarUri = Uri.https(
    'getstream.imgix.net',
    'images/random_svg/FS.png',
  );
  await chatRepository.connect(
    userId: userId,
    token: chatToken,
    avatarUri: avatarUri,
  );

  await runZonedGuarded(
    () async => runApp(await builder(
      (child) => chat_ui.StreamChat(
        client: chatClient,
        child: child,
      ),
      chatRepository,
    )),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
