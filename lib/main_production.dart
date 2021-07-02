// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/widgets.dart';

import 'package:chat_location/app/app.dart';
import 'package:chat_location/app/app_bloc_observer.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final chatClient = StreamChatClient(
    const String.fromEnvironment('STREAM_API_KEY'),
    logLevel: Level.OFF,
  );

  final chatRepository = ChatRepository(chatClient: chatClient);

  runZonedGuarded(
    () => runApp(App(chatRepository: chatRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
