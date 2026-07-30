import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/conversation_members.dart';
import 'package:obywatel_plus/core/database/tables/conversations.dart';
import 'package:obywatel_plus/core/database/tables/messages.dart';

part 'chats_dao.g.dart';

@DriftAccessor(tables: [Conversations, ConversationMembers, Messages])
class ChatsDao extends DatabaseAccessor<AppDatabase> with _$ChatsDaoMixin {
  ChatsDao(super.db);

  // --- CONVERSATIONS ---

  Stream<List<ConversationEntity>> watchActiveConversations() {
    return (select(conversations)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.updatedAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .watch();
  }

  Future<void> upsertConversations(List<ConversationsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(
        conversations,
        items,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  // --- MEMBERS ---

  Future<void> upsertMembers(List<ConversationMembersCompanion> members) async {
    await batch((batch) {
      batch.insertAll(
        conversationMembers,
        members,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> updateLastReadSequence({
    required String conversationId,
    required String userId,
    required BigInt sequence,
  }) async {
    await (update(conversationMembers)
          ..where(
            (t) =>
                t.conversationId.equals(conversationId) &
                t.userId.equals(userId),
          ))
        .write(
      ConversationMembersCompanion(
        lastReadSequence: Value(sequence),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // --- MESSAGES ---

  Stream<List<MessageEntity>> watchMessagesForConversation(String conversationId) {
    return (select(messages)
          ..where((t) => t.conversationId.equals(conversationId) & t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.sequence,
                  mode: OrderingMode.asc,
                ),
          ]))
        .watch();
  }

  Future<BigInt> getMaxMessageSequence(String conversationId) async {
    final maxSeqExpr = messages.sequence.max();
    final query = selectOnly(messages)
      ..addColumns([maxSeqExpr])
      ..where(messages.conversationId.equals(conversationId));
    
    final result = await query.map((row) => row.read(maxSeqExpr)).getSingleOrNull();
    return result ?? BigInt.zero;
  }

  Future<BigInt> getMaxMessageVersion() async {
    final maxVerExpr = messages.version.max();
    final query = selectOnly(messages)..addColumns([maxVerExpr]);
    
    final result = await query.map((row) => row.read(maxVerExpr)).getSingleOrNull();
    return result ?? BigInt.zero;
  }

  Future<void> upsertMessages(List<MessagesCompanion> newMessages) async {
    await transaction(() async {
      await batch((batch) {
        batch.insertAll(
          messages,
          newMessages,
          mode: InsertMode.insertOrReplace,
        );
      });

      // Aktualizacja lastSequence w konwersacji na podstawie najwyższej wstawionej sekwencji
      for (final msg in newMessages) {
        if (msg.conversationId.present && msg.sequence.present) {
          final convId = msg.conversationId.value;
          final seq = msg.sequence.value;

          await (update(conversations)..where((t) => t.id.equals(convId))).write(
            ConversationsCompanion(
              lastSequence: Value(seq),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }
    });
  }
}