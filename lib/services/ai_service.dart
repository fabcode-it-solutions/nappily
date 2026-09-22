import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:notizen/models/ai_message_model.dart';
import 'package:riverpod/riverpod.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  return AIService(dotenv.env['OPEN_AI_KEY'] ?? '');
});

class AIService {
  final String apiKey;

  AIService(this.apiKey);

  Future<String> getChatResponse(List<AIMessage> history) async {
    try {
      final uri = Uri.parse("https://api.openai.com/v1/chat/completions");

      final messages =
          history.map((m) {
            return {"role": m.isUser ? "user" : "assistant", "content": m.text};
          }).toList();

      const systemPrompt = '''
        You are a helpful assistant that provides information and answers questions about Baby and Sleep. If the user's query is not directly related to this area, politely reject it. 
        Please keep your answers short, simple, and easy to understand for new parents. 
        Avoid lengthy explanations unless necessary.
      ''';

      messages.insert(0, {"role": "system", "content": systemPrompt});

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({"model": "o4-mini-2025-04-16", "messages": messages}),
      );

      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw Exception(data['error']['message']);
      }
      return data['choices'][0]['message']['content'];
    } catch (e, stack) {
      print('AIService Error: $e\n$stack');
      return 'Oops! Something went wrong. Please try again later.';
    }
  }
}
