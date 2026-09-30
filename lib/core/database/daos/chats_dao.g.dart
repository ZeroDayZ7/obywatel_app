// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_dao.dart';

// ignore_for_file: type=lint
mixin _$ChatsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConversationsTable get conversations => attachedDatabase.conversations;
  $ConversationMembersTable get conversationMembers =>
      attachedDatabase.conversationMembers;
  $MessagesTable get messages => attachedDatabase.messages;
  ChatsDaoManager get managers => ChatsDaoManager(this);
}

class ChatsDaoManager {
  final _$ChatsDaoMixin _db;
  ChatsDaoManager(this._db);
  $$ConversationsTableTableManager get conversations =>
      $$ConversationsTableTableManager(_db.attachedDatabase, _db.conversations);
  $$ConversationMembersTableTableManager get conversationMembers =>
      $$ConversationMembersTableTableManager(
        _db.attachedDatabase,
        _db.conversationMembers,
      );
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
}
