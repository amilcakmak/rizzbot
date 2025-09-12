// api_manager.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAIAPI {
  static final apiKey = "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";
  
  Future<String> callGPT4(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {'Authorization': 'Bearer $apiKey'},
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": [{"role": "user", "content": prompt}],
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body)['choices'][0]['message']['content'];
      }
    } catch (e) {
      rethrow e;
    }
    
    throw Exception("API bağlantı hatası");
  }

}
