// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:chat_repository/chat_repository.dart';

void main() {
  group('ChatRepository', () {
    test('can be instantiated', () {
      expect(ChatRepository(), isNotNull);
    });
  });
}