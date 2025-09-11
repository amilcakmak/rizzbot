import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rizz/common/utils/app_colors.dart';
import 'package:rizz/common/utils/media_query.dart';
import 'package:rizz/common/widgets/gradient_button.dart';
import 'package:rizz/features/auth/view/gender_screen.dart';
import 'package:rizz/features/auth/view/name_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login-screen';
  LoginScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MQuery.getWidth(0.08),
            vertical: MQuery.getHeight(0.02),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              const Text(
                'Rizz',
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GradientButton(
                onPressed: () async {
                  try {
                    // Google ile giriş yapma süreci
                    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

                    if (googleUser == null) {
                      return;
                    }

                    // GoogleSignInAuthentication nesnesini al
                    final GoogleSignInAuthentication googleAuth =
                        await googleUser.authentication;
                    
                    // Kimlik doğrulama credential'ı oluştur
                    // 'accessToken' yerine 'idToken' ve 'accessToken' kullanıyoruz.
                    // Bu, Google paketi güncellemelerinden kaynaklanan bir değişiklik.
                    final OAuthCredential credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );
                    
                    // Firebase ile kimlik doğrulama
                    await _auth.signInWithCredential(credential);

                    // Başarılı giriş sonrası yönlendirme
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      NameScreen.routeName,
                      (route) => false,
                    );
                  } catch (e) {
                    print('Google Sign In Error: $e');
                  }
                },
                btnText: 'Google ile Devam Et',
                icon: FontAwesomeIcons.google,
              ),
              SizedBox(
                height: MQuery.getHeight(0.015),
              ),
              const Text(
                'Bir hesap oluşturarak veya giriş yaparak, \n Hizmet Şartları ve Gizlilik Politikası\'nı kabul etmiş olursun.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(
                height: MQuery.getHeight(0.015),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
