import 'package:equatable/equatable.dart';


class Chat extends Equatable {
  
  final String id;

  
  final String name;

  
  final List<String> participants;

  
  final String? avatarUrl;

  
  final DateTime createdAt;

  const Chat({
    required this.id,
    required this.name,
    required this.participants,
    this.avatarUrl,
    required this.createdAt,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'participants': participants,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      name: map['name'] as String,
      participants: List<String>.from(map['participants'] as Iterable? ?? []),
      avatarUrl: map['avatarUrl'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, participants, avatarUrl, createdAt];
}
