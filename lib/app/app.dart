// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:chat_location/channel_list/channel_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chat_location/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({Key? key, required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(key: key);

  final ChatRepository _chatRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _chatRepository,
      child: MaterialApp(
        theme: ThemeData(
          accentColor: const Color(0xFF13B9FF),
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ChannelListPage(),
      ),
    );
  }
}
