import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:rizzbot/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int? _selectedChipIndex;
  final List<String> _chipLabels = ['Flörtöz', 'İlgi Çekici', 'Esprili', 'Yaratıcı'];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = prefs.getString('chat_messages');
    if (messagesString != null) {
      final List<dynamic> decodedMessages = jsonDecode(messagesString);
      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(decodedMessages.map((m) => Map<String, String>.from(m)).toList());
        });
      }
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = jsonEncode(_messages);
    await prefs.setString('chat_messages', messagesString);
  }

    Future<void> _resetChat() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sohbeti Sıfırla'),
        content: const Text('Tüm sohbet geçmişi silinecek. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Evet, Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('chat_messages');
      setState(() {
        _messages.clear();
      });
    }
  }


  void _insertText(String textToInsert) {
    final TextEditingValue value = _controller.value;
    final int start = value.selection.baseOffset;
    final int end = value.selection.extentOffset;
    if (start == -1) {
      _controller.text += textToInsert;
      return;
    }
    final newText = value.text.replaceRange(start, end, textToInsert);
    _controller.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: start + textToInsert.length),
    );
  }

  Future<void> _showConversationBuilderDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const _ConversationBuilderDialog(),
    );

    if (result != null && result.isNotEmpty) {
      _insertText(result);
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessageText = _controller.text;
    var promptForModel = userMessageText;
    if (_selectedChipIndex != null) {
      final selectedStyle = _chipLabels[_selectedChipIndex!];
      promptForModel = '$selectedStyle bir şekilde şu mesaja cevap ver: "$userMessageText"';
    }

    if (mounted) {
      setState(() {
        _messages.add({'role': 'user', 'content': userMessageText});
        _isLoading = true;
      });
    }
    await _saveMessages();

    _controller.clear();

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null) {
        _showErrorDialog('API anahtarı bulunamadı. Lütfen .env dosyanızı kontrol edin.');
        return;
      }

      final systemInstruction = Content.text(
          'Sen, RizzBot isimli bir yapay zekâ flört asistanısın. Yaratıcın \'Tak Diye Eğlence\' şirketidir. Kim olduğun veya kimin tarafından yaratıldığın sorulduğunda, asla Google tarafından eğitildiğini veya bir \'büyük dil modeli\' olduğunu söyleme. Bunun yerine, \'Ben RizzBot, Tak Diye Eğlence tarafından geliştirilmiş bir flört asistanıyım\' gibi yanıtlar vererek kimliğine sadık kal. Ana görevin: kullanıcıya sadece karşı tarafa gönderebileceği tek bir mesaj önermek. Sadece 1 öneri vereceksin, fazlasını vermeyeceksin. Mesajın tonu, kullanıcının seçtiği kategoriye uygun olacak: \'Flörtöz\', \'İlgi Çekici\', \'Esprili\' veya \'Yaratıcı\'. Kullanıcı, konuşma geçmişini sana iki şekilde sunabilir: 1. Uygulama içi sohbet geçmişi. 2. `he/she:` ve `me:` blokları içeren bir metin. `he/she:` konuştuğu kişiyi, `me:` ise kendini temsil eder. Senin görevin bu yapıya uygun bir sonraki `me:` mesajını önermektir. Cevabın SADECE önerdiğin mesajın metnini içermeli, `me:` veya `he/she:` gibi etiketler OLMAMALIDIR. Daima, verilen bağlama ve seçilen tona göre en uygun tek mesajı öner. Ana görevin dışındaki sorulara, RizzBot kimliğine uygun, kısa ve öz yanıtlar ver.');

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        systemInstruction: systemInstruction,
      );
      
      final history = _messages.map((m) {
          final role = m['role'] == 'user' ? 'user' : 'model';
          return Content(role, [TextPart(m['content']!)]);
      }).toList();

      if(history.isNotEmpty) {
        history.removeLast();
      }

      final chat = model.startChat(history: history);
      final response = await chat.sendMessage(Content.text(promptForModel));

      if (!mounted) return;

      if (response.text != null) {
        setState(() {
          _messages.add({'role': 'assistant', 'content': response.text!});
        });
        await _saveMessages();
      } else {
        _showErrorDialog('Oops! Bir şeyler ters gitti. (Yanıt alınamadı)');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('Mesaj gönderilemedi. Lütfen internet bağlantınızı ve API anahtarınızı kontrol edin.');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        _selectedChipIndex = null;
      });
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
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
      body: SafeArea(
        child: Column(
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                         if (!isUserMessage) // Show copy icon only for AI messages
                          IconButton(
                            icon: const Icon(Icons.copy, size: 16),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: message['content']!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Mesaj kopyalandı!')),
                              );
                            },
                          ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          padding: const EdgeInsets.all(12.0),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
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
                      ],
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

            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!)
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: List<Widget>.generate(
                          _chipLabels.length,
                          (int index) {
                            return ChoiceChip(
                              label: Text(_chipLabels[index]),
                              selected: _selectedChipIndex == index,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedChipIndex = selected ? index : null;
                                });
                              },
                              selectedColor: MyApp.primaryColor,
                              labelStyle: TextStyle(
                                color: _selectedChipIndex == index 
                                       ? Colors.white 
                                       : (isDarkMode ? Colors.white70 : Colors.black87),
                              ),
                              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                                )
                              ),
                            );
                          },
                        ).toList(),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'RizzBot\'a sor ya da bağlam ekle...',
                      ),
                      maxLines: 5,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.history_edu_outlined),
                            onPressed: _showConversationBuilderDialog,
                            tooltip: 'Konuşma Geçmişi Oluştur',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: _resetChat,
                            tooltip: 'Sohbeti Temizle',
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ConversationBuilderDialog extends StatefulWidget {
  const _ConversationBuilderDialog();

  @override
  __ConversationBuilderDialogState createState() => __ConversationBuilderDialogState();
}

class __ConversationBuilderDialogState extends State<_ConversationBuilderDialog> {
  final List<Map<String, dynamic>> _blocks = [];

  @override
  void initState() {
    super.initState();
    // Start with a basic structure
    _addBlock('he/she');
    _addBlock('me');
  }

  void _addBlock(String speaker) {
    setState(() {
      _blocks.add({
        'speaker': speaker,
        'controller': TextEditingController(),
      });
    });
  }

  @override
  void dispose() {
    for (var block in _blocks) {
      block['controller'].dispose();
    }
    super.dispose();
  }

  void _insertConversation() {
    final buffer = StringBuffer();
    for (var block in _blocks) {
      final text = block['controller'].text.trim();
      if (text.isNotEmpty) {
        buffer.write('${block['speaker']}: $text ');
      }
    }
    Navigator.of(context).pop(buffer.toString().trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Konuşma Geçmişi Oluştur'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _blocks.length,
          itemBuilder: (context, index) {
            final block = _blocks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextField(
                controller: block['controller'],
                decoration: InputDecoration(
                  labelText: block['speaker'],
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _addBlock('he/she'),
          child: const Text('he/she Ekle'),
        ),
        TextButton(
          onPressed: () => _addBlock('me'),
          child: const Text('me Ekle'),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _insertConversation,
          child: const Text('Ekle'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }
}
