import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/models/ai_message_model.dart';
import 'package:notizen/services/ai_service.dart';

final aiMessagesProvider =
    StateNotifierProvider<AIMessagesNotifier, List<AIMessage>>((ref) {
      return AIMessagesNotifier(ref);
    });

class AIMessagesNotifier extends StateNotifier<List<AIMessage>> {
  final Ref ref;

  AIMessagesNotifier(this.ref) : super([]);

  Future<void> loadHistory(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('ai_chats')
            .orderBy('createdAt')
            .get();

    state = snapshot.docs.map((doc) => AIMessage.fromMap(doc.data())).toList();
  }

  Future<void> sendMessage(String userInput, String userId) async {
    final userMessage = AIMessage(
      text: userInput,
      isUser: true,
      isTyping: false,
      createdAt: DateTime.now(),
    );
    state = [...state, userMessage];

    final typingMessage = AIMessage(
      text: '',
      isUser: false,
      isTyping: true,
      createdAt: DateTime.now(),
    );
    state = [...state, typingMessage];

    await _saveToFirestore(userMessage, userId);

    final response = await ref.read(aiServiceProvider).getChatResponse(state);

    state = state.where((msg) => !msg.isTyping).toList();

    final aiMessage = AIMessage(
      text: response,
      isUser: false,
      isTyping: false,
      createdAt: DateTime.now(),
    );

    state = [...state, aiMessage];
    await _saveToFirestore(aiMessage, userId);
  }

  Future<void> _saveToFirestore(AIMessage message, String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('ai_chats')
        .add(message.toMap());
  }
}
