// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_location/l10n/l10n.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:chat_ui/chat_ui.dart' as chat_ui;
import 'package:mocktail/mocktail.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

class MockChatRepository extends Mock implements ChatRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {ChatRepository? chatRepository}) {
    return pumpWidget(
      RepositoryProvider.value(
        value: chatRepository ?? MockChatRepository(),
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: chat_ui.StreamChat(
            client: MockStreamChatClient(),
            child: widget,
          ),
        ),
      ),
    );
  }
}
