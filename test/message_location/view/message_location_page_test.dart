import 'package:chat_location/message_location/message_location.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class MockMessage extends Mock implements Message {}

class MockUser extends Mock implements User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<Attachment> attachments;
  late Message message;
  late User user;

  setUp(() {
    attachments = [
      Attachment(
        type: 'location',
        uploadState: const UploadState.success(),
        extraData: const {'latitude': 42.0, 'longitude': 42.0},
      ),
    ];
    message = MockMessage();
    user = MockUser();
  });

  group('MessageLocationPage', () {
    test('is routable', () {
      expect(
        MessageLocationPage.route(message),
        isA<MaterialPageRoute>(),
      );
    });

    testWidgets('navigates to page from route', (tester) async {
      when(() => user.name).thenReturn('John');
      when(() => message.user).thenReturn(user);
      when(() => message.attachments).thenReturn(attachments);

      await mockNetworkImages(() async {
        await tester.pumpApp(
          Navigator(
            onGenerateRoute: (_) => MessageLocationPage.route(message),
          ),
        );
        expect(find.text(user.name), findsOneWidget);
      });
    });

    testWidgets('renders a GoogleMap', (tester) async {
      when(() => user.name).thenReturn('John');
      when(() => message.user).thenReturn(user);
      when(() => message.attachments).thenReturn(attachments);
      await tester.pumpApp(
        MessageLocationPage(message: message),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GoogleMap), findsOneWidget);
    });
  });
}
