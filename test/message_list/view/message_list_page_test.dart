import 'package:chat_location/message_list/message_list.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:chat_ui/chat_ui.dart' as chat_ui;
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helpers.dart';

class MockChannel extends Mock implements Channel {}

class MockChannelClientState extends Mock implements ChannelClientState {}

class MockMessageListCubit extends MockCubit<MessageListState>
    implements MessageListCubit {}

class FakeMessageListState extends Fake implements MessageListState {}

void main() {
  late Channel channel;

  setUp(() {
    channel = MockChannel();

    final channelClientState = MockChannelClientState();
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
    });
    testWidgets('renders a chat_ui.MessageListView', (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      when(() => mockMessageListCubit.state)
          .thenReturn(MessageListState(channel: channel));
      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: const MessageListView(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.takeException();

      expect(find.byType(chat_ui.MessageListView), findsOneWidget);
    });

    testWidgets('renders a chat_ui.MessageInput', (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      when(() => mockMessageListCubit.state)
          .thenReturn(MessageListState(channel: channel));
      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: const MessageListView(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.takeException();

      expect(find.byType(chat_ui.MessageInput), findsOneWidget);
    });

    testWidgets('renders a Icons.location_history IconButton', (tester) async {
      final MessageListCubit mockMessageListCubit = MockMessageListCubit();
      when(() => mockMessageListCubit.state)
          .thenReturn(MessageListState(channel: channel));
      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: const MessageListView(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.takeException();

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
      await tester.pumpApp(
        BlocProvider.value(
          value: mockMessageListCubit,
          child: const MessageListView(),
        ),
      );
      await tester.tap(find.widgetWithIcon(IconButton, Icons.location_history));
      await tester.pumpAndSettle();
      await tester.takeException();
      verify(mockMessageListCubit.locationRequested).called(1);
    });

    testWidgets('renders SnackBar when state changes to unavailable',
        (tester) async {});

    testWidgets('renders map thumbnail when state changes to available',
        (tester) async {});
  });
}
