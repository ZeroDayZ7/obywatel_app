import 'package:equatable/equatable.dart';

/// Model czatu
class Chat extends Equatable {
  /// Unikalne ID czatu
  final String id;

  /// Nazwa czatu / tytuł
  final String name;

  /// Lista uczestników (np. ID użytkowników)
  final List<String> participants;

  /// URL lub ścieżka do avataru czatu
  final String? avatarUrl;

  /// Data utworzenia czatu
  final DateTime createdAt;

  const Chat({
    required this.id,
    required this.name,
    required this.participants,
    this.avatarUrl,
    required this.createdAt,
  });

  /// Konwersja do mapy (przydatne do Hive / JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'participants': participants,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Tworzenie obiektu z mapy (Hive / JSON)
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      name: map['name'] as String,
      participants: List<String>.from(map['participants'] ?? []),
      avatarUrl: map['avatarUrl'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, participants, avatarUrl, createdAt];
}
