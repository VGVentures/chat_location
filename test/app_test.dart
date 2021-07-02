// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:chat_location/channel_list/channel_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_location/app/app.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  group('App', () {
    late ChatRepository chatRepository;

    setUp(() {
      chatRepository = MockChatRepository();
    });

    testWidgets('renders ChannelListPage', (tester) async {
      await tester.pumpWidget(App(chatRepository: chatRepository));
      expect(find.byType(ChannelListPage), findsOneWidget);
    });
  });
}
