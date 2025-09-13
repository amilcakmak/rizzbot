import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizzbot/screens/login_screen.dart';
import 'dart:math';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile-screen';
  const ProfileScreen({Key? key}) : super(key: key);

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
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _userSubscription;

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
    _userSubscription.cancel();
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
      if (mounted) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    }
  }

  Future<void> _showAvatarSelectionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                      setState(() {
                        userPhotoUrl = avatarPath;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
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
                const Text('Adınızı ve soyadınızı giriniz.'),
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

  /// --- SAĞ ÜSTTE 3 NOKTA MENÜ ---
  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) async {
        if (value == 'settings') {
          // Ayarlar seçildi
        } else if (value == 'language') {
          // Dil seçildi
        } else if (value == 'logout') {
          await _auth.signOut();
          if (mounted) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'settings',
          child: Text('Ayarlar'),
        ),
        const PopupMenuItem(
          value: 'language',
          child: Text('Dil'),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Text('Çıkış'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6B45A6), Color(0xFF9B45C6)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 250.0,
              pinned: true,
              actions: [
                _buildPopupMenu(), // sağ üst 3 nokta menü
              ],
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double currentHeight = constraints.biggest.height;
                  final double maxExtent = 250.0;
                  final double minExtent = kToolbarHeight + MediaQuery.of(context).padding.top;
                  final double t = (1.0 - (currentHeight - minExtent) / (maxExtent - minExtent)).clamp(0.0, 1.0);

                  return Container(
                    color: Color.lerp(Colors.transparent, const Color(0xFF6B45A6), t),
                    child: FlexibleSpaceBar(
                      title: Opacity(
                        opacity: t,
                        child: const Text(
                          'Profil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      centerTitle: true,
                      background: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _showAvatarSelectionDialog,
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.white,
                                    backgroundImage: userPhotoUrl != null && userPhotoUrl!.isNotEmpty
                                        ? (userPhotoUrl!.startsWith('http')
                                        ? NetworkImage(userPhotoUrl!)
                                        : AssetImage(userPhotoUrl!) as ImageProvider)
                                        : null,
                                    child: userPhotoUrl == null || userPhotoUrl!.isEmpty
                                        ? const Icon(Icons.person, size: 70, color: Colors.deepPurple)
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${userName ?? 'Kullanıcı Adı'} ${userSurname ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: _showEditProfileDialog,
                                      icon: const Icon(Icons.edit, color: Colors.white),
                                      tooltip: 'Profili Düzenle',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Opacity(
                                  opacity: 1.0 - t,
                                  child: Text(
                                    userEmail ?? 'E-posta Yok',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Uygulama Hakkında',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'RizzBot, yapay zeka destekli bir sohbet robotu uygulamasıdır. Amacımız, kullanıcılarımıza kişiselleştirilmiş ve eğlenceli sohbet deneyimleri sunmaktır. Bu uygulama Flutter ve Firebase teknolojileri kullanılarak geliştirilmiştir.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Geliştirici Notları: Uygulama, sürekli olarak yeni özellikler ve iyileştirmelerle güncellenmektedir. Kullanıcı deneyimini en üst seviyeye çıkarmak için geri bildirimleriniz bizim için çok değerlidir.',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
