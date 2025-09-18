import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rizzbot/auth_service.dart';
import 'package:rizzbot/main.dart';
import 'package:rizzbot/providers/theme_provider.dart';
import 'package:rizzbot/screens/main_screen.dart';
import 'package:rizzbot/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthService _authService;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = FirebaseAuthService(FirebaseAuth.instance);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog("Lütfen e-posta ve şifrenizi girin.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.routeName, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Giriş işlemi başarısız. Lütfen tekrar deneyin.";
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        errorMessage = "Geçersiz e-posta veya şifre.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Geçersiz e-posta veya şifre.";
      } else {
        errorMessage = "Bir hata oluştu: ${e.message}";
      }
      if (mounted) {
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog("Beklenmedik bir hata oluştu: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
         if (mounted) setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.routeName, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog("Google ile giriş başarısız: $e");
      }
    } finally {
       if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showErrorDialog("Şifrenizi sıfırlamak için lütfen e-postanızı girin.");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("E-postanıza bir şifre sıfırlama bağlantısı gönderildi.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Giriş işlemi başarısız. Lütfen tekrar deneyin.";
      if (e.code == 'user-not-found') {
        errorMessage = "Bu e-posta adresine sahip bir kullanıcı bulunamadı.";
      }
      if (mounted) {
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog("Beklenmedik bir hata oluştu: $e");
      }
    }
  }

  void _showErrorDialog(String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          title: Text("Giriş Hatası", style: Theme.of(context).textTheme.titleLarge),
          content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tamam",
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : MyApp.primaryColor,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 10.0),
            child: ThemeToggleButton(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "RizzBot",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(2.0, 2.0),
                      ),
                    ]),
              ),
              const SizedBox(height: 8),
              Text(
                "Tekrar hoşgeldiniz!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : MyApp.primaryColor,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: "E-posta"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: "Şifre"),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: Text(
                    "Şifrenizi mi unuttunuz?",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : MyApp.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _signInWithEmail,
                      child: Text("Giriş Yap"),
                    ),
              const SizedBox(height: 20),
              _isLoading ? const SizedBox.shrink() : _buildGoogleSignInButton(),
              const SizedBox(height: 20),
               _isLoading ? const SizedBox.shrink() : _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return ElevatedButton.icon(
      onPressed: _signInWithGoogle,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white,
        foregroundColor: MyApp.primaryColor,
        elevation: 2,
        shadowColor: Colors.black38,
      ),
      icon: const FaIcon(FontAwesomeIcons.google, size: 20),
      label: Text("Google ile Devam Et",
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: MyApp.primaryColor)),
    );
  }

  Widget _buildSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Hesabınız yok mu?", style: Theme.of(context).textTheme.bodyMedium),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, SignUpScreen.routeName);
          },
          child: Text(
            "Kayıt Ol",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : MyApp.primaryColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
          ),
        ),
      ],
    );
  }
}


// --- Animasyonlu Tema Butonu ---
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
        return GestureDetector(
          onTap: () {
            themeProvider.toggleTheme();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  left: isDarkMode ? 45.0 : 5.0,
                  right: isDarkMode ? 5.0 : 45.0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return RotationTransition(turns: animation, child: child);
                    },
                    child: isDarkMode
                        ? Icon(Icons.nightlight_round, color: Colors.white, key: UniqueKey())
                        : Icon(Icons.wb_sunny_rounded, color: Colors.orange, key: UniqueKey()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
