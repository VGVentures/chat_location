// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:chat_location/bootstrap.dart';
import 'package:chat_repository/chat_repository.dart';

import 'package:chat_location/app/app.dart';

void main() async {
  await bootstrap(
    builder: ({required ChatRepository chatRepository}) async {
      return App(chatRepository: chatRepository);
    },
  );
}
