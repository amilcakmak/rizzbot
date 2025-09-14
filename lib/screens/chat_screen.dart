
// lib/screens/chat_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rizzbot/main.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    // Asenkron işlem öncesi state güncellemesi için mounted kontrolü
    if (mounted) {
      setState(() {
        _messages.add({'role': 'user', 'content': userMessage});
        _isLoading = true;
      });
    }

    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            ..._messages
          ],
        }),
      );
      
      // Asenkron işlem (API isteği) sonrası mounted kontrolü
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final botMessage = data['choices'][0]['message']['content'];

        setState(() {
          _messages.add({'role': 'assistant', 'content': botMessage});
        });
      } else {
         _showErrorDialog('Oops! Bir şeyler ters gitti. (Hata Kodu: ${response.statusCode})');
      }
    } catch (e) {
      // Hata yakalandıktan sonra mounted kontrolü
      if (!mounted) return;
      _showErrorDialog('Mesaj gönderilemedi. Lütfen internet bağlantınızı kontrol edin.');
    }

    // İşlem bittikten sonra mounted kontrolü
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return; // Dialog göstermeden önce de kontrol etmek en güvenlisidir.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: const Text('Hata'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Tamam'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('RizzBot ile Sohbet'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index];
                final isUserMessage = message['role'] == 'user';
                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      // HATA DÜZELTMESİ: 'MyApp.accentColor' tanımsızdı ve kaldırıldı.
                      // Kullanıcı mesajları için hem aydınlık hem de karanlık modda tutarlılık
                      // sağlamak amacıyla 'MyApp.primaryColor' kullanıldı.
                      color: isUserMessage
                          ? MyApp.primaryColor
                          : (isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      message['content']!,
                       style: TextStyle(
                        color: isUserMessage
                            ? Colors.white
                            : (isDarkMode ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Bir mesaj yaz...'),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  // İYİLEŞTİRME: Rengi doğrudan temadan almak daha robust bir yaklaşımdır.
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
