// lib/screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  String responseText = "";
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // TODO: Your Gemini API Key from Google AI Studio.
  // Bu kod, anahtarınızı uygulama içinde göstermektedir.
  // Güvenlik açısından, API anahtarınızı üretim ortamında bu şekilde
  // saklamamanız önerilir.
  static const String _apiKey = "AIzaSyB4XFHwSkPqdi1iSkiwvjAiWc_AkIX1LII"; // <-- API anahtarınızı buraya yapıştırın

  static const Color darkBlue = Color(0xFF2B2B4F);
  static const Color purple = Color(0xFF6B45A6);
  static const Color lightPurple = Color(0xFF9B45C6);

  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);

  void _generateResponse(String prompt) async {
    if (prompt.isEmpty) return;
    if (_apiKey.isEmpty) {
      setState(() {
        _messages.add('RizzBot: API anahtarı ayarlanmamış. Lütfen _apiKey değişkenini güncelleyin.');
      });
      return;
    }

    setState(() {
      _messages.add('Sen: $prompt');
      responseText = "Yükleniyor...";
    });

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      String aiResponse = response.text ?? "Yanıt alınamadı.";

      setState(() {
        responseText = ""; // Placeholder'ı temizle
        _messages.add('RizzBot: $aiResponse');
        _controller.clear();
      });
    } catch (e) {
      setState(() {
        responseText = "";
        _messages.add('RizzBot: Bir hata oluştu: ${e.toString()}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          currentUser?.displayName ?? "RizzBot",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final reversedIndex = _messages.length - 1 - index;
                final message = _messages[reversedIndex];
                final isUserMessage = message.startsWith('Sen:');

                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isUserMessage ? lightPurple : Colors.grey[800],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: isUserMessage ? const Radius.circular(20) : const Radius.circular(5),
                        bottomRight: isUserMessage ? const Radius.circular(5) : const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      message.replaceFirst(isUserMessage ? 'Sen: ' : 'RizzBot: ', ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (responseText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  responseText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Bir mesaj yazın...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
                onSubmitted: _generateResponse,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [purple, lightPurple],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _generateResponse(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
