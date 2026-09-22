class AIMessage {
  final String text;
  final bool isUser;
  final DateTime createdAt;
  final bool isTyping;

  AIMessage({
    required this.text,
    required this.isUser,
    required this.createdAt,
    this.isTyping = false,
  });

  Map<String, dynamic> toMap() => {
    'text': text,
    'isUser': isUser,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AIMessage.fromMap(Map<String, dynamic> map) => AIMessage(
    text: map['text'],
    isUser: map['isUser'],
    createdAt: DateTime.parse(map['createdAt']),
  );
}
