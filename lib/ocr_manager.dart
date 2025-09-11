import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'dart:io';

class OCRManager {
  
  static final tesseract = TesseractOcr();

  Future<String> extractTextFromImage(String imagePath) async {
    try {
      // Google ML Kit veya başka bir OCR servisini kullanacağız
    } catch (e) {
      rethrow e.toString();
    }
    
    throw Exception("OCR işlemi hatası");
  }
}
