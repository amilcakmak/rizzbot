// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizzbot/screens/chat_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
  String? userEmail;
  bool _isDarkMode = false;
  String _selectedLanguage = 'Türkçe';
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          setState(() {
            userName = userData['name'] as String?;
            userEmail = user.email;
          });
        }
      } else {
        setState(() {
          userEmail = user.email;
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final user = _auth.currentUser;
        if (user == null) {
          return;
        }

        final file = File(image.path);
        final storageRef = FirebaseStorage.instance.ref().child('user_avatars/${user.uid}.png');
        final uploadTask = storageRef.putFile(file);

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadURL = await snapshot.ref.getDownloadURL();

        await user.updatePhotoURL(downloadURL);

        setState(() {
          _isUploading = false;
        });

      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        // Hata durumunda kullanıcıya bilgi ver
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fotoğraf yükleme hatası: $e')),
        );
      }
    }
  }

  Future<void> _showEditNameDialog() async {
    final TextEditingController nameController = TextEditingController(text: userName);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('İsmi Düzenle'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Yeni isim'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Kaydet'),
              onPressed: () async {
                await _updateUserName(nameController.text);
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

  Future<void> _updateUserName(String newName) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(newName);
      await _firestore.collection('users').doc(user.uid).set(
        {'name': newName},
        SetOptions(merge: true),
      );
      setState(() {
        userName = newName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? photoURL = _auth.currentUser?.photoURL;
    ImageProvider<Object> profileImage;

    if (photoURL != null && photoURL.isNotEmpty) {
      profileImage = NetworkImage(photoURL);
    } else {
      profileImage = const AssetImage('assets/images/user.png');
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 250.0,
                  pinned: true,
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final top = constraints.biggest.height;
                      final minHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
                      final progress = (top - minHeight) / (250.0 - minHeight);

                      return FlexibleSpaceBar(
                        centerTitle: true,
                        background: Opacity(
                          opacity: 1.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.deepPurple, Color(0xFF9B45C6)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: _pickAndUploadImage,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 50 * (progress > 0.5 ? 1.0 : progress * 2),
                                          backgroundImage: profileImage,
                                          backgroundColor: Colors.grey,
                                        ),
                                        if (_isUploading)
                                          const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    userName ?? 'İsimsiz Kullanıcı',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black.withOpacity(0.5 * (1.0 - progress)),
                                        )
                                      ]
                                    ),
                                  ),
                                  Text(
                                    userEmail ?? '',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(progress),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        title: Opacity(
                          opacity: 1.0 - progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[850]?.withOpacity(1.0 - progress),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage: profileImage,
                                    backgroundColor: Colors.grey,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Profil',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(1.0 - progress),
                                      fontWeight: FontWeight.bold,
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
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          GestureDetector(
                            onLongPress: _showEditNameDialog,
                            child: Text(
                              userName ?? 'İsimsiz Kullanıcı',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Text(
                            userEmail ?? '',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton.icon(
                            onPressed: _showEditNameDialog,
                            icon: const Icon(Icons.edit, color: Colors.deepPurple),
                            label: const Text('İsmi Düzenle', style: TextStyle(color: Colors.deepPurple)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, ChatScreen.routeName);
                            },
                            icon: const Icon(Icons.chat_bubble_outline, color: Colors.deepPurple),
                            label: const Text('Sohbete Başla', style: TextStyle(color: Colors.deepPurple)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              if (mounted) {
                                Navigator.pushReplacementNamed(context, '/');
                              }
                            },
                            icon: const Icon(Icons.exit_to_app, color: Colors.deepPurple),
                            label: const Text('Çıkış Yap', style: TextStyle(color: Colors.deepPurple)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            color: Colors.grey[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        // Ayarlar menüsüne tıklandığında yapılacak işlemler
                      },
                    ),
                    const SizedBox(height: 20),
                    // Karanlık/Aydınlık mod anahtarı
                    Column(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.white),
                        Switch(
                          value: _isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              _isDarkMode = value;
                            });
                            // Tema değişikliğini burada yönet
                          },
                          activeColor: Colors.deepPurple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Dil seçeneği
                    Column(
                      children: [
                        const Icon(Icons.language, color: Colors.white),
                        DropdownButton<String>(
                          value: _selectedLanguage,
                          icon: const Icon(Icons.arrow_downward, color: Colors.white),
                          dropdownColor: Colors.grey[850],
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedLanguage = newValue!;
                            });
                            // Dil değişikliğini burada yönet
                          },
                          items: <String>['Türkçe', 'English', 'Español']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    },
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
