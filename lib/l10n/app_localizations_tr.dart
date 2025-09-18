// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'RizzBot';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navChat => 'Sohbet';

  @override
  String get navProfile => 'Profil';

  @override
  String get themeChange => 'Temayı Değiştir';

  @override
  String get languageChange => 'Dili Değiştir';

  @override
  String get homeScreenSwayingText => 'Onu etkilemek mi istiyorsun? 💫\nYoksa işi büyütüp tamamen elde etmek mi?\nBelki de sadece muhabbeti akıcı tutmak istiyorsun...\n\nNe olursa olsun, doğru yerdesin!\nRizzBot senin gizli silahın — en doğru cümleleri, en doğru anda sana fısıldar.\n\nŞimdi vakit kaybetme, hamleni yap! 😉';

  @override
  String homeScreenWelcome(Object userName) {
    return 'Hoş geldin, $userName!';
  }

  @override
  String get user => 'Kullanıcı';

  @override
  String homeScreenEmail(Object email) {
    return 'E-posta: $email';
  }

  @override
  String get notAvailable => 'Yok';

  @override
  String get selectAvatarTitle => 'Avatar Seç';

  @override
  String get closeButton => 'Kapat';

  @override
  String get editProfileTitle => 'Profili Düzenle';

  @override
  String get nameLabel => 'Ad';

  @override
  String get surnameLabel => 'Soyad';

  @override
  String get cancelButton => 'İptal';

  @override
  String get saveButton => 'Kaydet';

  @override
  String get profileTitle => 'Profil';

  @override
  String get emailNotAvailable => 'E-posta Yok';

  @override
  String get aboutAppTitle => 'Uygulama Hakkında';

  @override
  String get aboutAppText => 'RizzBot, yapay zeka destekli bir sohbet robotu uygulamasıdır. Amacımız, kullanıcılarımıza kişiselleştirilmiş ve eğlenceli sohbet deneyimleri sunmaktır. Bu uygulama Flutter ve Firebase teknolojileri kullanılarak geliştirilmiştir.';

  @override
  String get developerNotesTitle => 'Geliştirici Notları';

  @override
  String get developerNotesText => 'Uygulama, sürekli olarak yeni özellikler ve iyileştirmelerle güncellenmektedir. Kullanıcı deneyimini en üst seviyeye çıkarmak için geri bildirimleriniz bizim için çok değerlidir.';

  @override
  String get logoutButton => 'Çıkış Yap';

  @override
  String get errorEmailPasswordEmpty => 'E-posta ve şifre boş bırakılamaz.';

  @override
  String get errorLoginFailed => 'Giriş başarısız oldu.';

  @override
  String get errorUserNotFound => 'Bu e-posta veya şifre ile bir hesap bulunamadı.';

  @override
  String get errorWrongPassword => 'Yanlış şifre. Lütfen tekrar deneyin.';

  @override
  String errorGenericWithCode(Object message) {
    return 'Bir hata oluştu: $message';
  }

  @override
  String errorUnexpected(Object error) {
    return 'Beklenmedik bir hata oluştu: $error';
  }

  @override
  String errorGoogleSignIn(Object error) {
    return 'Google ile giriş sırasında bir hata oluştu: $error';
  }

  @override
  String get errorResetPasswordEmailEmpty => 'Şifre sıfırlama için lütfen e-posta adresinizi girin.';

  @override
  String get infoPasswordResetEmailSent => 'Şifre sıfırlama e-postası gönderildi.';

  @override
  String get errorUserNotFoundPasswordReset => 'Bu e-posta adresine sahip bir kullanıcı bulunamadı.';

  @override
  String get titleLoginError => 'Giriş Hatası';

  @override
  String get okButton => 'Tamam';

  @override
  String get appName => 'Rizz Bot';

  @override
  String get welcomeBack => 'Tekrar hoş geldin';

  @override
  String get emailHint => 'E-posta';

  @override
  String get passwordHint => 'Şifre';

  @override
  String get forgotPasswordButton => 'Şifremi Unuttum?';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get continueWithGoogleButton => 'Google ile Devam Et';

  @override
  String get dontHaveAccount => 'Hesabın yok mu?';

  @override
  String get signUpButton => 'Kayıt Ol';

  @override
  String get errorSignUpFailed => 'Kayıt başarısız oldu.';

  @override
  String get errorWeakPassword => 'Şifre çok zayıf. Lütfen daha güçlü bir şifre seçin.';

  @override
  String get errorEmailInUse => 'Bu e-posta adresi zaten kullanılıyor.';

  @override
  String get errorInvalidEmail => 'Geçersiz e-posta adresi.';

  @override
  String errorUnknown(Object error) {
    return 'Bilinmeyen bir hata oluştu: $error';
  }

  @override
  String get titleSignUpError => 'Kayıt Hatası';

  @override
  String get validatorInvalidEmail => 'Lütfen geçerli bir e-posta girin.';

  @override
  String get validatorPasswordLength => 'Şifre en az 6 karakter olmalıdır.';

  @override
  String get createAccountTitle => 'Yeni Hesap Oluştur';

  @override
  String get alreadyHaveAccountLogin => 'Zaten hesabın var mı? Giriş Yap';

  @override
  String get styleFlirtatious => 'Flörtöz';

  @override
  String get styleEngaging => 'İlgi Çekici';

  @override
  String get styleWitty => 'Esprili';

  @override
  String get styleCreative => 'Yaratıcı';

  @override
  String get titleResetChat => 'Sohbeti Sıfırla';

  @override
  String get bodyResetChat => 'Tüm sohbet geçmişi silinecek. Emin misiniz?';

  @override
  String get confirmDeleteButton => 'Evet, Sil';

  @override
  String get errorApiKeyNotFound => 'API anahtarı bulunamadı. Lütfen .env dosyanızı kontrol edin.';

  @override
  String get errorNoResponse => 'Oops! Bir şeyler ters gitti. (Yanıt alınamadı)';

  @override
  String get errorCouldNotSendMessage => 'Mesaj gönderilemedi. Lütfen internet bağlantınızı ve API anahtarınızı kontrol edin.';

  @override
  String get titleError => 'Hata';

  @override
  String get infoMessageCopied => 'Mesaj kopyalandı!';

  @override
  String get chatHintText => 'RizzBot\'a sor ya da bağlam ekle...';

  @override
  String get titleConversationBuilder => 'Konuşma Geçmişi Oluştur';

  @override
  String get tooltipClearChat => 'Sohbeti Temizle';

  @override
  String get addButtonHeShe => 'he/she Ekle';

  @override
  String get addButtonMe => 'me Ekle';

  @override
  String get addButton => 'Ekle';

  @override
  String get geminiSystemInstruction => 'Sen, RizzBot isimli bir yapay zekâ flört asistanısın. Yaratıcın \'Tak Diye Eğlence\' şirketidir. Kim olduğun veya kimin tarafından yaratıldığın sorulduğunda, asla Google tarafından eğitildiğini veya bir \'büyük dil modeli\' olduğunu söyleme. Bunun yerine, \'Ben RizzBot, Tak Diye Eğlence tarafından geliştirilmiş bir flört asistanıyım\' gibi yanıtlar vererek kimliğine sadık kal. Ana görevin: kullanıcıya sadece karşı tarafa gönderebileceği tek bir mesaj önermek. Sadece 1 öneri vereceksin, fazlasını vermeyeceksin. Mesajın tonu, kullanıcının seçtiği kategoriye uygun olacak: \'Flörtöz\', \'İlgi Çekici\', \'Esprili\' veya \'Yaratıcı\'. Kullanıcı, konuşma geçmişini sana iki şekilde sunabilir: 1. Uygulama içi sohbet geçmişi. 2. `he/she:` ve `me:` blokları içeren bir metin. `he/she:` konuştuğu kişiyi, `me:` ise kendini temsil eder. Senin görevin bu yapıya uygun bir sonraki `me:` mesajını önermektir. Cevabın SADECE önerdiğin mesajın metnini içermeli, `me:` veya `he/she:` gibi etiketler OLMAMALIDIR. Daima, verilen bağlama ve seçilen tona göre en uygun tek mesajı öner. Ana görevin dışındaki sorulara, RizzBot kimliğine uygun, kısa ve öz yanıtlar ver.';

  @override
  String geminiPrompt(Object message, Object style) {
    return 'Şu mesaja $style bir şekilde cevap ver: \"$message\"';
  }

  @override
  String get errorRestartApp => 'Bir hata oluştu. Lütfen uygulamayı yeniden başlatın.';
}
