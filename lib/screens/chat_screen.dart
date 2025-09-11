// chat_screen.dart dosyasında
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  
  // Metin kutusu ve butonlar
  
  Future<void> generateResponse(String prompt) async {
    setState(() {
      responseText = "Yükleniyor...";
    });
    
    try {
      String? response;
      
      if (prompt.length > 100) { // Eğer metin uzunsa OCR kullan
        response = await OCRManager.extractTextFromImage(prompt);
      } else {
        response = await OpenAIAPI.callGPT4(prompt);
      }
      
      setState(() {
        responseText = response;
      });
    } catch (e) {
      // Hata yönetimi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RizzBot")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: ListView.builder(...)), // Chat geçmişini göstermek için
            TextFormField(controller: _controller), // Giriş alanı
            ElevatedButton(onPressed: () => generateResponse(_controller.text), child: Text("Cevap Üret")),
          ],
        ),
      ),
    );
  }
}
