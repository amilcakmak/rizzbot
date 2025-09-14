import 'package:tesseract_ocr/tesseract_ocr.dart';

class OCRManager {
  
  static final tesseract = TesseractOcr();

  Future<String> extractTextFromImage(String imagePath) async {
    try {
      // Google ML Kit veya başka bir OCR servisini kullanacağız
    } catch (e) {
      rethrow;
    }
    
    throw Exception("OCR işlemi hatası");
  }
}
