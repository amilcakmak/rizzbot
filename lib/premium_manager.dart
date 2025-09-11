// premium_manager.dart
import 'package:rizzbot/screens/home_screen.dart';

class PremiumManager {
  
  static const freeLimitPerDay = 3;
  static const freeLimitPerHour = 5;

  Future<bool> canGenerateResponse() async {
    // Firebase'den kullanıcının bugün yapabileceği ücretsiz cevap sayısını kontrol et
    return true; // Placeholder için basitçe döndürdük, gerçek uygulamada Firebase verilerini kontrol edeceğiz
  }

}
