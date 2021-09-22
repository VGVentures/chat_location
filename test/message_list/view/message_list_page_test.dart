import 'package:bloc_test/bloc_test.dart';
import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:chat_ui/chat_ui.dart' as chat_ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class MockChannel extends Mock implements Channel {}

class MockChannelClientState extends Mock implements ChannelClientState {}

class MockMessage extends Mock implements Message {}

class MockMessageListCubit extends MockCubit<MessageListState>
    implements MessageListCubit {}

class FakeMessageListState extends Fake implements MessageListState {}

class FakePageRoute extends Fake implements PageRoute<dynamic> {}

void main() {
  late Channel channel;
  late ChannelClientState channelClientState;

  setUp(() {
    channel = MockChannel();
    channelClientState = MockChannelClientState();

    when(() => channel.initialized).thenAnswer((_) async => true);
    when(() => channel.on(any(), any(), any(), any())).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => channel.state).thenReturn(channelClientState);
    when(() => channelClientState.threadsStream).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => channelClientState.messagesStream).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(() => channelClientState.messages).thenReturn([]);
    when(() => channelClientState.isUpToDate).thenReturn(true);
  });

  group('MessageListPage', () {
    testWidgets('renders a MessageListView', (tester) async {
      await tester.pumpApp(
        MessageListPage(channel: channel),
      );
      await tester.pumpAndSettle();
      await tester.takeException();
      expect(find.byType(MessageListView), findsOneWidget);
    });
  });

  group('MessageListView', () {
    setUpAll(() {
      registerFallbackValue<MessageListState>(FakeMessageListState());
      registerFallbackValue<PageRoute<dynamic>>(FakePageRoute());
    });

    testWidgets('renders a chat_ui.MessageListView', (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      when(() => mockMessageListCubit.state)
          .thenReturn(MessageListState(channel: channel));
      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: const Scaffold(body: MessageListView()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(chat_ui.MessageListView), findsOneWidget);
    });

    testWidgets('renders a chat_ui.MessageInput', (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      when(() => mockMessageListCubit.state)
          .thenReturn(MessageListState(channel: channel));
      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: const Scaffold(body: MessageListView()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(chat_ui.MessageInput), findsOneWidget);
    });

    testWidgets('renders a Icons.location_history IconButton', (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      when(() => mockMessageListCubit.state)
          .thenReturn(MessageListState(channel: channel));
      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: const Scaffold(body: MessageListView()),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithIcon(IconButton, Icons.location_history),
        findsOneWidget,
      );
    });

    testWidgets('calls MessageListCubit.locationRequested on IconButton tap',
        (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      when(() => mockMessageListCubit.state)
          .thenReturn(MessageListState(channel: channel));
      when(mockMessageListCubit.locationRequested).thenAnswer((_) async {});
      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: const Scaffold(body: MessageListView()),
        ),
      );
      await tester.tap(find.widgetWithIcon(IconButton, Icons.location_history));
      await tester.pumpAndSettle();
      verify(mockMessageListCubit.locationRequested).called(1);
    });

    testWidgets('renders SnackBar when state changes to unavailable',
        (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      whenListen(
        mockMessageListCubit,
        Stream.fromIterable(<MessageListState>[
          MessageListState(channel: channel),
          MessageListState(
            channel: channel,
            location: const CurrentLocation(
              status: CurrentLocationStatus.unavailable,
            ),
          ),
        ]),
        initialState: MessageListState(channel: channel),
      );
      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: const Scaffold(body: MessageListView()),
        ),
      );
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('renders map thumbnail when state changes to available',
        (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      whenListen(
        mockMessageListCubit,
        Stream.fromIterable(<MessageListState>[
          MessageListState(channel: channel),
          MessageListState(
            channel: channel,
            location: const CurrentLocation(
              status: CurrentLocationStatus.available,
            ),
          ),
        ]),
        initialState: MessageListState(channel: channel),
      );

      await mockNetworkImages(() async {
        await tester.pumpApp(
          BlocProvider.value(
            value: mockMessageListCubit,
            child: const Scaffold(body: MessageListView()),
          ),
        );
        await tester.pump();
        expect(find.byType(MapThumbnailImage), findsOneWidget);
      });
    });

    testWidgets('renders attachment view ', (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      when(() => mockMessageListCubit.state)
          .thenReturn(MessageListState(channel: channel));

      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: chat_ui.MessageListView(
            channel: channel,
            onGenerateAttachments: {
              'location': (_, message) => AttachmentView(message: message),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(chat_ui.MessageListView), findsOneWidget);
    });

    testWidgets(
        'renders attachment with map thumbnail image '
        'when given channel and message', (tester) async {
      final message = MockMessage();

      when(() => message.attachments).thenReturn([
        Attachment(
          type: 'location',
          uploadState: const UploadState.success(),
          extraData: const {'latitude': 42.0, 'longitude': 42.0},
        ),
      ]);

      await tester.pumpApp(
        Scaffold(body: AttachmentView(message: message)),
      );

      await tester.ensureVisible(find.byType(AttachmentView));
      await tester.pumpAndSettle();
      expect(find.byType(chat_ui.Attachment), findsOneWidget);
      expect(find.byType(MapThumbnailImage), findsOneWidget);
    });

    testWidgets(
        'navigates to MessageLocationPage '
        'when pressing Attachment', (tester) async {
      final navigator = MockNavigator();
      final message = MockMessage();
      final attachments = [
        Attachment(
          type: 'location',
          uploadState: const UploadState.success(),
          extraData: const {'latitude': 42.0, 'longitude': 42.0},
        ),
      ];

      when(() => navigator.push(any())).thenAnswer((_) async {});
      when(() => message.attachments).thenReturn(attachments);

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: Scaffold(
            body: AttachmentView(message: message),
          ),
        ),
      );
      await tester.ensureVisible(find.byType(AttachmentView));
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      verify(() => navigator.push(any(that: isRoute<void>()))).called(1);
    });
  });
}
