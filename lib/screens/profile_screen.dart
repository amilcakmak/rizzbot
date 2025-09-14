
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizzbot/main.dart';
import 'package:rizzbot/screens/login_screen.dart';
import 'dart:math';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile-screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userName;
  String? userSurname;
  String? userEmail;
  String? userPhotoUrl;
  bool _isLoading = true;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSubscription;

  final List<String> _localAvatars = List.generate(
    150,
        (index) => 'assets/images/avatar${index + 1}.png',
  );

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  String _getRandomAvatar() {
    final random = Random();
    return _localAvatars[random.nextInt(_localAvatars.length)];
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      _userSubscription = _firestore.collection('users').doc(user.uid).snapshots().listen((userDoc) {
        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null && mounted) {
            setState(() {
              userName = userData['name'] as String?;
              userSurname = userData['surname'] as String?;
              userPhotoUrl = userData['photoUrl'] as String?;
              userEmail = user.email;
              _isLoading = false;
            });
          }
        } else {
          final defaultPhotoUrl = _getRandomAvatar();
          if (mounted) {
            setState(() {
              userEmail = user.email;
              userPhotoUrl = defaultPhotoUrl;
              _isLoading = false;
            });
          }
          _firestore.collection('users').doc(user.uid).set({
            'name': '',
            'surname': '',
            'photoUrl': userPhotoUrl,
          });
        }
      });
    } else {
      // HATA DÜZELTMESİ: Asenkron boşluktan sonra context kullanımı için mounted kontrolü eklendi.
      if (mounted) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    }
  }

  Future<void> _showAvatarSelectionDialog() async {
    // HATA DÜZELTMESİ: Asenkron boşluktan sonra context kullanımı için mounted kontrolü eklendi.
    if (!mounted) return;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          title: const Text('Avatar Seç'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400.0,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _localAvatars.length,
              itemBuilder: (context, index) {
                final avatarPath = _localAvatars[index];
                return GestureDetector(
                  onTap: () async {
                    final user = _auth.currentUser;
                    if (user != null) {
                      await _firestore.collection('users').doc(user.uid).update({
                        'photoUrl': avatarPath,
                      });
                    }
                    // HATA DÜZELTMESİ: Asenkron boşluktan sonra context kullanımı için mounted kontrolü eklendi.
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: AssetImage(avatarPath),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditProfileDialog() async {
    // HATA DÜZELTMESİ: Asenkron boşluktan sonra context kullanımı için mounted kontrolü eklendi.
    if (!mounted) return;
    final TextEditingController nameController = TextEditingController(text: userName);
    final TextEditingController surnameController = TextEditingController(text: userSurname);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profili Düzenle'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Ad'),
                ),
                TextFormField(
                  controller: surnameController,
                  decoration: const InputDecoration(labelText: 'Soyad'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Kaydet'),
              onPressed: () async {
                final user = _auth.currentUser;
                if (user != null) {
                  await _firestore.collection('users').doc(user.uid).update({
                    'name': nameController.text.trim(),
                    'surname': surnameController.text.trim(),
                  });
                }
                // HATA DÜZELTMESİ: Asenkron boşluktan sonra context kullanımı için mounted kontrolü eklendi.
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    // HATA DÜZELTMESİ: Asenkron boşluktan sonra context kullanımı için mounted kontrolü eklendi.
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 280.0,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double top = constraints.biggest.height;
                final bool isCollapsed = top <= kToolbarHeight + MediaQuery.of(context).padding.top + 20;

                return FlexibleSpaceBar(
                  title: isCollapsed
                      ? Text(
                    'Profil',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: isDarkMode ? Colors.white : Colors.black),
                  )
                      : null,
                  centerTitle: true,
                  background: Container(
                     decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [Colors.black, Colors.grey[900]!]
                            // HATA DÜZELTMESİ: 'MyApp.backgroundColor' tanımsızdı.
                            // Temaya uygun 'scaffoldBackgroundColor' kullanıldı.
                            // 'withOpacity' yerine modern '.withAlpha()' kullanıldı.
                            : [Theme.of(context).scaffoldBackgroundColor, MyApp.primaryColor.withAlpha(26)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _showAvatarSelectionDialog,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                backgroundImage: userPhotoUrl != null && userPhotoUrl!.isNotEmpty
                                    ? (userPhotoUrl!.startsWith('http')
                                    ? NetworkImage(userPhotoUrl!)
                                    : AssetImage(userPhotoUrl!) as ImageProvider)
                                    : null,
                                child: userPhotoUrl == null || userPhotoUrl!.isEmpty
                                    ? Icon(Icons.person, size: 70, color: isDarkMode ? Colors.white70 : MyApp.primaryColor)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${userName ?? 'Kullanıcı'} ${userSurname ?? ''}'.trim(),
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: _showEditProfileDialog,
                                  icon: Icon(Icons.edit, color: isDarkMode ? Colors.white70 : Colors.grey[600]),
                                  tooltip: 'Profili Düzenle',
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              userEmail ?? 'E-posta Yok',
                               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isDarkMode ? Colors.white70 : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Uygulama Hakkında',
                     style: Theme.of(context).textTheme.titleLarge
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'RizzBot, yapay zeka destekli bir sohbet robotu uygulamasıdır. Amacımız, kullanıcılarımıza kişiselleştirilmiş ve eğlenceli sohbet deneyimleri sunmaktır. Bu uygulama Flutter ve Firebase teknolojileri kullanılarak geliştirilmiştir.',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Geliştirici Notları: Uygulama, sürekli olarak yeni özellikler ve iyileştirmelerle güncellenmektedir. Kullanıcı deneyimini en üst seviyeye çıkarmak için geri bildirimleriniz bizim için çok değerlidir.',
                     style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Çıkış Yap'),
                    style: ElevatedButton.styleFrom(
                      // HATA DÜZELTMESİ: 'withOpacity' yerine modern '.withAlpha()' kullanıldı.
                      backgroundColor: isDarkMode ? Colors.red.withAlpha(204) : Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
